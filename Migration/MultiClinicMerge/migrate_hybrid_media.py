"""
Migrate and Organize Cloud / Hybrid Media Files for Multi-Clinic Helianz.

Resolves patient images/files from source clinics (e.g. Klaten, Jogja, Boyolali)
in iDrive / S3 / SFTP cloud storage (rclone remote) and moves them into the correct
Helianz Hybrid Storage path:
    {remote}:{serverBase}/{bucket}/{targetPatNum}/{FileName}
where:
    bucket = targetPatNum % 100 (folders '0' through '99')

Safety:
    - Runs in DRY-RUN mode by default (no files touched).
    - Generates a CSV audit report of all planned moves before execution.
    - Server-side move/copy within S3/iDrive e2 (instant, zero download bandwidth).
    - Supports --copy (non-destructive copy instead of move).

Usage:
    # 1. Preview planned moves (DRY RUN):
    python migrate_hybrid_media.py --dry-run

    # 2. Preview specific clinics (e.g. Klaten and Jogja):
    python migrate_hybrid_media.py --clinics klt,jog --dry-run

    # 3. Specify custom remote profile and database:
    python migrate_hybrid_media.py --remote helianz-media:dsmile/HelianzImages --db helianz --dry-run

    # 4. Execute actual moves after verifying the dry-run:
    python migrate_hybrid_media.py --execute

    # 5. Non-destructive copy (leaves original files intact):
    python migrate_hybrid_media.py --execute --copy
"""

import os
import sys
import argparse
import subprocess
import time
import csv
import threading
from datetime import datetime
from concurrent.futures import ThreadPoolExecutor, as_completed
try:
    import mysql.connector
except ModuleNotFoundError:
    # Auto-switch to project virtual environment if available
    cur_dir = os.path.dirname(os.path.abspath(__file__))
    venv_python = None
    for _ in range(4):
        cand = os.path.join(cur_dir, ".venv", "Scripts", "python.exe")
        if os.path.exists(cand) and cand.lower() != sys.executable.lower():
            venv_python = cand
            break
        p = os.path.dirname(cur_dir)
        if p == cur_dir:
            break
        cur_dir = p

    if venv_python:
        ret = subprocess.run([venv_python] + sys.argv)
        sys.exit(ret.returncode)

    print("[!] Error: Python module 'mysql-connector-python' is not installed.")
    print(f"    Current Python: {sys.executable}")
    print("\n    To run with project virtual environment:")
    print(r"    ..\..\.venv\Scripts\python.exe migrate_hybrid_media.py " + " ".join(sys.argv[1:]))
    print("\n    Or install into current Python:")
    print("    pip install mysql-connector-python")
    sys.exit(1)

# ── Defaults ──
DEFAULT_REMOTE = "helianz-media:dsmile/HelianzImages"
DEFAULT_DB = "helianz"
DEFAULT_HOST = os.environ.get("MYSQL_HOST", "localhost")
DEFAULT_PORT = int(os.environ.get("MYSQL_TCP_PORT", "3306"))
DEFAULT_USER = os.environ.get("MYSQL_USER", "root")
DEFAULT_PASSWORD = os.environ.get("MYSQL_PWD", "J0k0m4r0k3@")

CLINIC_DEFAULTS = {
    1: {"name": "Klaten", "abbr": "klt", "offset": 0},
    2: {"name": "Boyolali", "abbr": "byl", "offset": 1_000_000},
    3: {"name": "Jogja", "abbr": "jog", "offset": 2_000_000},
}


def log(msg):
    ts = datetime.now().strftime("%H:%M:%S.%f")[:-3]
    print(f"[{ts}] {msg}", flush=True)


def get_db_connection(db=DEFAULT_DB, host=DEFAULT_HOST, port=DEFAULT_PORT, user=DEFAULT_USER, password=DEFAULT_PASSWORD):
    """Create a MariaDB/MySQL connection in pure-Python mode."""
    for use_pure in [True, False]:
        try:
            return mysql.connector.connect(
                host=host,
                port=port,
                user=user,
                password=password,
                database=db,
                use_pure=use_pure,
                ssl_disabled=True,
                connection_timeout=30,
                charset="utf8mb4"
            )
        except Exception:
            if not use_pure:
                raise


def find_rclone_exe(custom_path=None):
    """Locate rclone executable."""
    candidates = [
        custom_path,
        "rclone",
        "rclone.exe",
        os.path.join(os.path.dirname(os.path.abspath(__file__)), "rclone.exe"),
        r"C:\Program Files\Helianz\rclone\rclone.exe",
        r"C:\Program Files (x86)\Helianz\rclone\rclone.exe",
    ]
    for c in candidates:
        if not c:
            continue
        try:
            res = subprocess.run([c, "version"], capture_output=True, text=True, timeout=5)
            if res.returncode == 0:
                return c
        except Exception:
            continue
    return None


def get_remote_file_list(rclone_exe, remote_path, cache_file="rclone_files_cache.txt", use_cache=False):
    """List all files currently in the rclone remote path."""
    if use_cache and os.path.exists(cache_file):
        log(f"Loading remote file list from cache: {cache_file} ...")
        with open(cache_file, "r", encoding="utf-8", errors="replace") as f:
            files = [line.strip().replace("\\", "/") for line in f if line.strip()]
        log(f"Loaded {len(files):,} files from cache.")
        return files

    log(f"Scanning remote storage via rclone: '{remote_path}' ...")
    cmd = [rclone_exe, "lsf", "-R", "--files-only", remote_path]
    t0 = time.time()
    proc = subprocess.run(cmd, capture_output=True, text=True, encoding="utf-8", errors="replace")
    if proc.returncode != 0:
        err = proc.stderr.strip() or proc.stdout.strip()
        raise RuntimeError(f"rclone lsf failed (code {proc.returncode}): {err}")

    raw_lines = proc.stdout.splitlines()
    files = [line.strip().replace("\\", "/") for line in raw_lines if line.strip()]
    elapsed = time.time() - t0
    log(f"Found {len(files):,} files on remote in {elapsed:.2f}s.")

    # Save cache for faster re-runs
    try:
        with open(cache_file, "w", encoding="utf-8") as f:
            for item in files:
                f.write(item + "\n")
    except Exception:
        pass

    return files


def load_clinic_info_from_db(conn, db_name):
    """
    Read clinics from database and dynamically calculate offsets from MIN(PatNum).
    """
    cursor = conn.cursor(dictionary=True)
    clinics = {}

    # Check if clinic table exists
    cursor.execute("SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = %s AND TABLE_NAME = 'clinic'", (db_name,))
    if cursor.fetchone()["COUNT(*)"] > 0:
        cursor.execute(f"SELECT ClinicNum, Description, Abbr FROM `{db_name}`.`clinic`")
        for r in cursor.fetchall():
            c_num = r["ClinicNum"]
            clinics[c_num] = {
                "name": r["Description"] or f"Clinic {c_num}",
                "abbr": (r["Abbr"] or f"c{c_num}").lower().replace(" ", ""),
                "offset": 0
            }

    # Calculate offset per clinic from MIN(PatNum) in patient table
    cursor.execute(f"SELECT ClinicNum, MIN(PatNum) as MinPat FROM `{db_name}`.`patient` GROUP BY ClinicNum")
    for r in cursor.fetchall():
        c_num = r["ClinicNum"]
        min_pat = r["MinPat"] or 0
        offset = (min_pat // 1_000_000) * 1_000_000
        if c_num in clinics:
            clinics[c_num]["offset"] = offset
        else:
            clinics[c_num] = {"name": f"Clinic {c_num}", "abbr": f"c{c_num}", "offset": offset}

    cursor.close()
    return clinics


def load_database_documents(conn, db_name, clinic_filter=None, clinics_map=None):
    """
    Load all patients and documents from the database.
    Returns:
        documents: list of dicts with patient and document details
    """
    cursor = conn.cursor(dictionary=True)

    # Check if this is the merged database with ClinicNum column in patient
    cursor.execute(f"SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = %s AND TABLE_NAME = 'patient' AND COLUMN_NAME = 'ClinicNum'", (db_name,))
    has_clinic = cursor.fetchone()["COUNT(*)"] > 0

    log(f"Querying patient documents from database `{db_name}` ...")
    query = f"""
        SELECT 
            p.PatNum,
            {"p.ClinicNum" if has_clinic else "1 AS ClinicNum"},
            p.LName,
            p.FName,
            COALESCE(p.ImageFolder, '') AS ImageFolder,
            d.DocNum,
            d.FileName,
            d.DateCreated
        FROM `{db_name}`.`patient` p
        INNER JOIN `{db_name}`.`document` d ON p.PatNum = d.PatNum
        WHERE d.FileName IS NOT NULL AND d.FileName != ''
    """
    cursor.execute(query)
    rows = cursor.fetchall()
    cursor.close()

    log(f"Loaded {len(rows):,} document records from database `{db_name}`.")

    # Apply clinic filter if specified
    if clinic_filter and clinics_map:
        valid_clinics = set()
        for cf in clinic_filter:
            cf_str = str(cf).strip().lower()
            for c_num, info in clinics_map.items():
                c_name_lower = info["name"].lower()
                c_abbr_lower = info["abbr"].lower()
                if (cf_str == str(c_num) or 
                    cf_str in c_name_lower or 
                    cf_str in c_abbr_lower or 
                    c_abbr_lower.startswith(cf_str) or 
                    c_name_lower.startswith(cf_str)):
                    valid_clinics.add(c_num)
        if valid_clinics:
            rows = [r for r in rows if r["ClinicNum"] in valid_clinics]
            clinic_descs = [f"{clinics_map[c]['name']} ({c})" for c in sorted(valid_clinics)]
            log(f"Filtered to {len(rows):,} documents for clinics: {', '.join(clinic_descs)}")

    return rows


def build_candidate_source_paths(doc, clinic_info):
    """
    Generate possible current locations for a document on the remote storage.
    Covers:
      1. Correct hybrid path: {bucket}/{targetPatNum}/{FileName}
      2. Old un-offset numbered path: {oldBucket}/{oldPatNum}/{FileName}
      3. Clinic-prefixed numbered path: {clinicAbbr}/{oldBucket}/{oldPatNum}/{FileName}
      4. Clinic-prefixed folder: {clinicAbbr}/{oldPatNum}/{FileName}
      5. Legacy A-Z alphabetical path: {Letter}/{ImageFolder}/{FileName}
      6. Clinic-prefixed A-Z path: {clinicAbbr}/{Letter}/{ImageFolder}/{FileName}
      7. Plain folder: {ImageFolder}/{FileName}
    """
    pat_num = doc["PatNum"]
    offset = clinic_info.get("offset", 0)
    old_pat_num = pat_num - offset if pat_num > offset else pat_num

    target_bucket = str(pat_num % 100)
    old_bucket = str(old_pat_num % 100)
    filename = doc["FileName"]
    img_folder = doc.get("ImageFolder", "").strip()
    c_abbr = clinic_info.get("abbr", "").lower()
    c_name = clinic_info.get("name", "").lower()

    candidates = []

    # 1. Correct hybrid path (already where it should be)
    target_path = f"{target_bucket}/{pat_num}/{filename}"

    # 2. Old numbered paths
    candidates.append(f"{old_bucket}/{old_pat_num}/{filename}")
    candidates.append(f"{old_pat_num}/{filename}")

    # 3. Clinic-prefixed paths (e.g. klt/, jog/, byl/, Klaten/, Jogja/)
    for pfx in [c_abbr, c_name]:
        if pfx:
            candidates.append(f"{pfx}/{old_bucket}/{old_pat_num}/{filename}")
            candidates.append(f"{pfx}/{old_pat_num}/{filename}")
            candidates.append(f"{pfx}/{target_bucket}/{pat_num}/{filename}")

    # 4. Legacy A-to-Z paths
    if img_folder:
        letter = img_folder[0].upper()
        candidates.append(f"{letter}/{img_folder}/{filename}")
        candidates.append(f"{img_folder}/{filename}")
        for pfx in [c_abbr, c_name]:
            if pfx:
                candidates.append(f"{pfx}/{letter}/{img_folder}/{filename}")
                candidates.append(f"{pfx}/{img_folder}/{filename}")

    # 5. Patient name based legacy folder
    lname = (doc.get("LName") or "").strip()
    fname = (doc.get("FName") or "").strip()
    if lname:
        name_folder = f"{lname}{fname}{old_pat_num}"
        letter = lname[0].upper()
        candidates.append(f"{letter}/{name_folder}/{filename}")
        candidates.append(f"{name_folder}/{filename}")
        for pfx in [c_abbr, c_name]:
            if pfx:
                candidates.append(f"{pfx}/{letter}/{name_folder}/{filename}")

    return target_path, candidates


def plan_media_migration(db_docs, remote_files, clinics_map=None):
    """
    Match database documents to actual remote files and build an action plan.
    """
    if clinics_map is None:
        clinics_map = CLINIC_DEFAULTS

    # Build fast lookup sets and filename index
    remote_file_set = set(remote_files)
    remote_lower_map = {f.lower(): f for f in remote_files}

    # Index by filename alone and filename+parent
    filename_to_paths = {}
    for f in remote_files:
        basename = os.path.basename(f)
        filename_to_paths.setdefault(basename.lower(), []).append(f)

    actions = []
    stats = {
        "total_db_docs": len(db_docs),
        "already_correct": 0,
        "planned_moves": 0,
        "not_found_on_remote": 0,
        "by_clinic": {}
    }

    log("Matching database records against remote file index ...")

    for doc in db_docs:
        c_num = doc["ClinicNum"]
        clinic_info = clinics_map.get(c_num, {"name": f"Clinic {c_num}", "abbr": f"c{c_num}", "offset": 0})
        c_name = clinic_info["name"]
        stats["by_clinic"].setdefault(c_name, {"already_correct": 0, "move": 0, "not_found": 0})

        target_path, candidates = build_candidate_source_paths(doc, clinic_info)

        # Check if already at target path
        if target_path in remote_file_set or target_path.lower() in remote_lower_map:
            actual_target = target_path if target_path in remote_file_set else remote_lower_map[target_path.lower()]
            actions.append({
                "status": "ALREADY_CORRECT",
                "clinic": c_name,
                "pat_num": doc["PatNum"],
                "doc_num": doc["DocNum"],
                "filename": doc["FileName"],
                "source_path": actual_target,
                "target_path": target_path
            })
            stats["already_correct"] += 1
            stats["by_clinic"][c_name]["already_correct"] += 1
            continue

        # Try candidate paths
        found_source = None
        for cand in candidates:
            if cand in remote_file_set:
                found_source = cand
                break
            if cand.lower() in remote_lower_map:
                found_source = remote_lower_map[cand.lower()]
                break

        # Fallback: search by filename and match parent folder containing patnum or imagefolder
        if not found_source:
            fname_lower = doc["FileName"].lower()
            matches = filename_to_paths.get(fname_lower, [])
            if len(matches) == 1:
                found_source = matches[0]
            elif len(matches) > 1:
                # Disambiguate by checking if old_patnum, target_patnum, or imagefolder is in the path
                pat_str = str(doc["PatNum"])
                offset = clinic_info.get("offset", 0)
                old_pat_str = str(doc["PatNum"] - offset)
                img_str = doc.get("ImageFolder", "").lower()

                for m in matches:
                    m_parts = m.lower().split("/")
                    if pat_str in m_parts or old_pat_str in m_parts or (img_str and img_str in m_parts):
                        found_source = m
                        break

        if found_source:
            actions.append({
                "status": "MOVE",
                "clinic": c_name,
                "pat_num": doc["PatNum"],
                "doc_num": doc["DocNum"],
                "filename": doc["FileName"],
                "source_path": found_source,
                "target_path": target_path
            })
            stats["planned_moves"] += 1
            stats["by_clinic"][c_name]["move"] += 1
        else:
            actions.append({
                "status": "NOT_FOUND",
                "clinic": c_name,
                "pat_num": doc["PatNum"],
                "doc_num": doc["DocNum"],
                "filename": doc["FileName"],
                "source_path": "",
                "target_path": target_path
            })
            stats["not_found_on_remote"] += 1
            stats["by_clinic"][c_name]["not_found"] += 1

    return actions, stats


def export_plan_csv(actions, csv_file="migrate_media_plan.csv"):
    """Export action plan to a CSV spreadsheet."""
    log(f"Writing audit plan to CSV: {csv_file} ...")
    with open(csv_file, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=["status", "clinic", "pat_num", "doc_num", "filename", "source_path", "target_path"])
        writer.writeheader()
        writer.writerows(actions)
    log(f"[OK] Audit plan saved to {csv_file} ({len(actions):,} entries)")


def execute_moves(rclone_exe, remote_base, actions, copy_mode=False, max_workers=16):
    """
    Execute the planned file moves/copies via rclone.
    Uses server-side operations (moveto / copyto) within the remote storage in parallel.
    """
    moves = [a for a in actions if a["status"] == "MOVE"]
    total = len(moves)
    action_verb = "copyto" if copy_mode else "moveto"

    log("\n" + "=" * 70)
    log(f"EXECUTING {total:,} FILE {'COPIES' if copy_mode else 'MOVES'} via rclone {action_verb}")
    log(f"Parallel Workers: {max_workers} threads")
    log("=" * 70)

    success = 0
    failed = 0
    counter = 0
    lock = threading.Lock()
    t0 = time.time()

    def do_task(act):
        nonlocal success, failed, counter
        src = f"{remote_base}/{act['source_path']}"
        dst = f"{remote_base}/{act['target_path']}"
        cmd = [rclone_exe, action_verb, src, dst]
        try:
            res = subprocess.run(cmd, capture_output=True, text=True, timeout=60)
            with lock:
                counter += 1
                curr = counter
                if res.returncode == 0:
                    success += 1
                    if curr <= 10 or curr % 500 == 0 or curr == total:
                        pct = (curr / total) * 100
                        log(f"[{curr:,}/{total:,} ({pct:.1f}%)] [OK] {act['source_path']} -> {act['target_path']}")
                else:
                    failed += 1
                    err = res.stderr.strip() or res.stdout.strip()
                    log(f"[{curr:,}/{total:,}] [ERROR] {act['source_path']} -> {act['target_path']}: {err}")
        except Exception as ex:
            with lock:
                counter += 1
                failed += 1
                log(f"[{counter:,}/{total:,}] [EXCEPTION] {act['source_path']} -> {act['target_path']}: {ex}")

    with ThreadPoolExecutor(max_workers=max_workers) as executor:
        futures = [executor.submit(do_task, act) for act in moves]
        for f in as_completed(futures):
            pass

    elapsed = time.time() - t0
    rate = total / elapsed if elapsed > 0 else 0
    log("\n" + "=" * 70)
    log(f"EXECUTION SUMMARY: {success:,} succeeded, {failed:,} failed in {elapsed:.2f}s ({rate:.1f} files/sec)")
    log("=" * 70)


def main():
    parser = argparse.ArgumentParser(
        description="Migrate and organize cloud/hybrid media files for multi-clinic Helianz",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python migrate_hybrid_media.py --dry-run
  python migrate_hybrid_media.py --clinics klt,jog --dry-run
  python migrate_hybrid_media.py --execute
  python migrate_hybrid_media.py --execute --copy
        """
    )
    parser.add_argument("--remote", default=DEFAULT_REMOTE, help=f"rclone remote path (default: {DEFAULT_REMOTE})")
    parser.add_argument("--db", default=DEFAULT_DB, help=f"Target merged database name (default: {DEFAULT_DB})")
    parser.add_argument("--host", default=DEFAULT_HOST, help=f"MySQL host (default: {DEFAULT_HOST})")
    parser.add_argument("--port", type=int, default=DEFAULT_PORT, help=f"MySQL port (default: {DEFAULT_PORT})")
    parser.add_argument("--user", default=DEFAULT_USER, help=f"MySQL user (default: {DEFAULT_USER})")
    parser.add_argument("--password", default=None, help="MySQL password (defaults to MYSQL_PWD)")
    parser.add_argument("--clinics", default=None, help="Filter clinics: comma-separated names, abbrs, or IDs (e.g. klt,jog)")
    parser.add_argument("--rclone", default=None, help="Custom path to rclone executable")
    parser.add_argument("--use-cache", action="store_true", help="Use local cache file if available instead of re-scanning remote")
    parser.add_argument("--dry-run", action="store_true", default=True, help="Preview moves without making changes (default)")
    parser.add_argument("--execute", action="store_true", help="Execute the actual moves on the remote storage")
    parser.add_argument("--copy", action="store_true", help="Copy instead of move (non-destructive)")
    parser.add_argument("--workers", type=int, default=16, help="Number of parallel worker threads (default: 16)")
    parser.add_argument("--csv", default="migrate_media_plan.csv", help="Output path for plan CSV audit report")

    args = parser.parse_args()

    # Determine execution mode:
    # If user explicitly passed --execute, then dry_run is False
    is_dry_run = not args.execute

    log("=" * 70)
    log("  HELIANZ HYBRID CLOUD MEDIA MIGRATION TOOL")
    log("=" * 70)
    log(f"  Remote Storage : {args.remote}")
    log(f"  Database       : {args.db} on {args.host}:{args.port}")
    log(f"  Mode           : {'DRY-RUN (SIMULATION ONLY - NO FILES TOUCHED)' if is_dry_run else 'EXECUTE (REAL MOVES/COPIES)'}")
    if not is_dry_run:
        log(f"  Operation      : {'COPY (Non-destructive)' if args.copy else 'MOVE (Server-side Rename)'}")
        log(f"  Parallelism    : {args.workers} worker threads")
    if args.clinics:
        log(f"  Clinic Filter  : {args.clinics}")

    # 1. Locate rclone
    rclone_exe = find_rclone_exe(args.rclone)
    if not rclone_exe:
        log("\n[!] Error: rclone executable not found!")
        log("    Please ensure rclone is in your PATH or specify --rclone <path_to_rclone.exe>")
        sys.exit(1)
    log(f"  rclone Binary  : {rclone_exe}")

    # 2. Connect to Database
    db_pass = args.password if args.password is not None else DEFAULT_PASSWORD
    try:
        conn = get_db_connection(db=args.db, host=args.host, port=args.port, user=args.user, password=db_pass)
        log(f"  [OK] Connected to database `{args.db}` successfully.")
    except Exception as e:
        log(f"\n[!] Failed to connect to database `{args.db}`: {e}")
        sys.exit(1)

    # 3. Load clinic metadata & dynamic offsets from DB
    clinics_map = load_clinic_info_from_db(conn, args.db)
    log(f"  Clinics in Database: {len(clinics_map)}")
    for c_num, info in sorted(clinics_map.items()):
        log(f"    - Clinic {c_num} ({info['name']}, {info['abbr']}): offset +{info['offset']:,}")

    # 4. Load DB Documents
    clinic_filter = [c.strip() for c in args.clinics.split(",")] if args.clinics else None
    db_docs = load_database_documents(conn, args.db, clinic_filter=clinic_filter, clinics_map=clinics_map)
    conn.close()

    if not db_docs:
        log("\n[!] No document records found in database matching criteria. Exiting.")
        sys.exit(0)

    # 5. Scan Remote Storage
    try:
        remote_files = get_remote_file_list(rclone_exe, args.remote, use_cache=args.use_cache)
    except Exception as e:
        log(f"\n[!] Failed to scan remote storage: {e}")
        sys.exit(1)

    # 6. Build Move Plan
    actions, stats = plan_media_migration(db_docs, remote_files, clinics_map=clinics_map)

    # 6. Print Summary Report
    log("\n" + "=" * 70)
    log("  MIGRATION AUDIT SUMMARY")
    log("=" * 70)
    log(f"  Total DB Documents   : {stats['total_db_docs']:,}")
    log(f"  Already Correct      : {stats['already_correct']:,} ({stats['already_correct']/stats['total_db_docs']*100:.1f}%)")
    log(f"  Need to be Moved     : {stats['planned_moves']:,} ({stats['planned_moves']/stats['total_db_docs']*100:.1f}%)")
    log(f"  Not Found on Remote  : {stats['not_found_on_remote']:,} ({stats['not_found_on_remote']/stats['total_db_docs']*100:.1f}%)")
    log("\n  Breakdown by Clinic:")
    for c_name, c_stat in stats["by_clinic"].items():
        log(f"    - {c_name:12}: {c_stat['move']:,} to move, {c_stat['already_correct']:,} already correct, {c_stat['not_found']:,} not found")

    # Sample Planned Moves
    moves = [a for a in actions if a["status"] == "MOVE"]
    if moves:
        log(f"\n  Sample Planned Moves (showing first 10 of {len(moves):,}):")
        for m in moves[:10]:
            log(f"    [{m['clinic']}] {m['source_path']}  --->  {m['target_path']}")

    # 7. Export CSV Report
    export_plan_csv(actions, args.csv)

    # 8. Execute or Stop
    if is_dry_run:
        log("\n" + "=" * 70)
        log("  DRY-RUN COMPLETE — NO FILES WERE MOVED OR MODIFIED.")
        log(f"  Review '{args.csv}' to inspect every planned move.")
        log("  When ready to execute, re-run with: --execute")
        log("=" * 70)
    else:
        if moves:
            execute_moves(rclone_exe, args.remote, actions, copy_mode=args.copy, max_workers=args.workers)
        else:
            log("\nNo files need to be moved. All files are already in their correct locations!")


if __name__ == "__main__":
    main()

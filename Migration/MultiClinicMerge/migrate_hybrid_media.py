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
        with open(cache_file, "r", encoding="utf-8", errors="replace") as f:
            files = [line.strip().replace("\\", "/") for line in f if line.strip()]
        if len(files) > 0:
            log(f"Loading remote file list from cache: {cache_file} ...")
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

    # 1. Correct hybrid path (e.g. for Klaten or when source already has target structure)
    target_path = f"{target_bucket}/{pat_num}/{filename}"
    candidates.append(target_path)

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


def plan_media_migration(db_docs, source_files, dest_files, clinics_map=None, same_remote=True, copy_mode=True):
    """
    Match database documents to remote files and build an action plan.
    - Files already in dest are skipped (ALREADY_IN_DEST) so nothing is overwritten.
    - Files found in source are queued for transfer (COPY or MOVE).
    - Files not found in source are skipped (SKIPPED_NOT_FOUND) so migration can be re-run next time.
    """
    if clinics_map is None:
        clinics_map = CLINIC_DEFAULTS

    dest_file_set = set(dest_files)
    dest_lower_map = {f.lower(): f for f in dest_files}

    source_file_set = set(source_files)
    source_lower_map = {f.lower(): f for f in source_files}
    source_filename_to_paths = {}
    for f in source_files:
        basename = os.path.basename(f)
        source_filename_to_paths.setdefault(basename.lower(), []).append(f)

    actions = []
    stats = {
        "total_db_docs": len(db_docs),
        "already_in_dest": 0,
        "ready_to_transfer": 0,
        "skipped_not_found": 0,
        "by_clinic": {}
    }

    log("Matching database records against source & destination file indexes ...")

    for doc in db_docs:
        c_num = doc["ClinicNum"]
        clinic_info = clinics_map.get(c_num, {"name": f"Clinic {c_num}", "abbr": f"c{c_num}", "offset": 0})
        c_name = clinic_info["name"]
        stats["by_clinic"].setdefault(c_name, {"already_in_dest": 0, "transfer": 0, "skipped_not_found": 0})

        target_path, candidates = build_candidate_source_paths(doc, clinic_info)

        # 1. Protection: Check if already in destination (DO NOT OVERWRITE)
        if target_path in dest_file_set or target_path.lower() in dest_lower_map:
            actual_target = target_path if target_path in dest_file_set else dest_lower_map[target_path.lower()]
            actions.append({
                "status": "ALREADY_IN_DEST",
                "clinic": c_name,
                "pat_num": doc["PatNum"],
                "doc_num": doc["DocNum"],
                "filename": doc["FileName"],
                "source_path": actual_target if same_remote else "",
                "target_path": actual_target
            })
            stats["already_in_dest"] += 1
            stats["by_clinic"][c_name]["already_in_dest"] += 1
            continue

        # 2. Search in source files
        found_source = None
        for cand in candidates:
            if cand in source_file_set:
                found_source = cand
                break
            if cand.lower() in source_lower_map:
                found_source = source_lower_map[cand.lower()]
                break

        # Fallback search by filename
        if not found_source:
            fname_lower = doc["FileName"].lower()
            matches = source_filename_to_paths.get(fname_lower, [])
            if len(matches) == 1:
                found_source = matches[0]
            elif len(matches) > 1:
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
            act_verb = "COPY" if copy_mode else "MOVE"
            actions.append({
                "status": act_verb,
                "clinic": c_name,
                "pat_num": doc["PatNum"],
                "doc_num": doc["DocNum"],
                "filename": doc["FileName"],
                "source_path": found_source,
                "target_path": target_path
            })
            stats["ready_to_transfer"] += 1
            stats["by_clinic"][c_name]["transfer"] += 1
        else:
            # Not in source yet - skip safely so user can re-run next time!
            actions.append({
                "status": "SKIPPED_NOT_FOUND",
                "clinic": c_name,
                "pat_num": doc["PatNum"],
                "doc_num": doc["DocNum"],
                "filename": doc["FileName"],
                "source_path": "",
                "target_path": target_path
            })
            stats["skipped_not_found"] += 1
            stats["by_clinic"][c_name]["skipped_not_found"] += 1

    return actions, stats


def export_plan_csv(actions, csv_file="migrate_media_plan.csv"):
    """Export action plan to a CSV spreadsheet."""
    log(f"Writing audit plan to CSV: {csv_file} ...")
    with open(csv_file, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=["status", "clinic", "pat_num", "doc_num", "filename", "source_path", "target_path"])
        writer.writeheader()
        writer.writerows(actions)
    log(f"[OK] Audit plan saved to {csv_file} ({len(actions):,} entries)")


def execute_moves(rclone_exe, source_remote, dest_remote, actions, copy_mode=True, max_workers=16, dest_cache=None):
    """
    Execute the planned file moves/copies via rclone in parallel.
    Uses --ignore-existing on copies to prevent overwriting destination files.
    """
    transfers = [a for a in actions if a["status"] in ("COPY", "MOVE")]
    total = len(transfers)
    action_verb = "copyto" if copy_mode else "moveto"

    log("\n" + "=" * 70)
    log(f"EXECUTING {total:,} FILE {'COPIES' if copy_mode else 'MOVES'} via rclone {action_verb}")
    log(f"  Source Remote : {source_remote}")
    log(f"  Dest Remote   : {dest_remote}")
    log(f"  Workers       : {max_workers} threads")
    if copy_mode:
        log("  Protection    : --ignore-existing enabled (will not overwrite destination)")
    log("=" * 70)

    success = 0
    failed = 0
    counter = 0
    lock = threading.Lock()
    successful_targets = []
    t0 = time.time()

    def do_task(act):
        nonlocal success, failed, counter
        src = f"{source_remote}/{act['source_path']}"
        dst = f"{dest_remote}/{act['target_path']}"
        cmd = [rclone_exe, action_verb]
        if copy_mode:
            cmd.append("--ignore-existing")
        cmd.extend([src, dst])

        try:
            res = subprocess.run(cmd, capture_output=True, text=True, timeout=60)
            with lock:
                counter += 1
                curr = counter
                if res.returncode == 0:
                    success += 1
                    successful_targets.append(act["target_path"])
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
        futures = [executor.submit(do_task, act) for act in transfers]
        for f in as_completed(futures):
            pass

    # Save/append newly transferred files to destination cache
    if dest_cache and successful_targets:
        try:
            with open(dest_cache, "a", encoding="utf-8") as f:
                for tgt in successful_targets:
                    f.write(tgt + "\n")
            debug_log(f"Updated {dest_cache} with {len(successful_targets):,} new entries.")
        except Exception:
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
  # 1. Preview full migration for ALL clinics (non-destructive copy dry-run):
  python migrate_hybrid_media.py --dry-run

  # 2. Preview copying to a different destination folder:
  python migrate_hybrid_media.py --dest helianz-media:dsmile/HelianzImagesNew --dry-run

  # 3. Preview specific clinics only:
  python migrate_hybrid_media.py --clinics byl,jog --dry-run

  # 4. Execute non-destructive copy with 16 parallel threads:
  python migrate_hybrid_media.py --execute

  # 5. Execute with custom destination:
  python migrate_hybrid_media.py --dest helianz-media:dsmile/HelianzImagesNew --execute
        """
    )
    parser.add_argument("--remote", default=DEFAULT_REMOTE, help=f"Source rclone remote path (default: {DEFAULT_REMOTE})")
    parser.add_argument("--dest", default=None, help="Destination rclone remote path (default: same as --remote)")
    parser.add_argument("--db", default=DEFAULT_DB, help=f"Target merged database name (default: {DEFAULT_DB})")
    parser.add_argument("--host", default=DEFAULT_HOST, help=f"MySQL host (default: {DEFAULT_HOST})")
    parser.add_argument("--port", type=int, default=DEFAULT_PORT, help=f"MySQL port (default: {DEFAULT_PORT})")
    parser.add_argument("--user", default=DEFAULT_USER, help=f"MySQL user (default: {DEFAULT_USER})")
    parser.add_argument("--password", default=None, help="MySQL password (defaults to MYSQL_PWD)")
    parser.add_argument("--clinics", default=None, help="Filter clinics: comma-separated names, abbrs, or IDs (default: ALL clinics)")
    parser.add_argument("--rclone", default=None, help="Custom path to rclone executable")
    parser.add_argument("--use-cache", action="store_true", help="Use local cache file if available instead of re-scanning remote")
    parser.add_argument("--rescan-dest", action="store_true", help="Force live scan of destination remote (bypasses dest cache)")
    parser.add_argument("--dry-run", action="store_true", default=True, help="Preview transfers without making changes (default)")
    parser.add_argument("--execute", action="store_true", help="Execute the actual transfers on the remote storage")
    parser.add_argument("--move", action="store_true", help="Move instead of copy (warning: removes source files)")
    parser.add_argument("--copy", action="store_true", default=True, help="Copy files non-destructively (default)")
    parser.add_argument("--workers", type=int, default=16, help="Number of parallel worker threads (default: 16)")
    parser.add_argument("--csv", default="migrate_media_plan.csv", help="Output path for plan CSV audit report")

    args = parser.parse_args()

    # Execution and transfer modes
    is_dry_run = not args.execute
    copy_mode = not args.move  # Defaults to True (copy) unless --move is passed explicitly

    source_remote = args.remote.rstrip("/\\")
    dest_remote = args.dest.rstrip("/\\") if args.dest else source_remote
    same_remote = (source_remote.lower() == dest_remote.lower())

    log("=" * 70)
    log("  HELIANZ HYBRID CLOUD MEDIA MIGRATION TOOL")
    log("=" * 70)
    log(f"  Source Storage : {source_remote}")
    log(f"  Dest Storage   : {dest_remote} {'(Same bucket)' if same_remote else '(New location)'}")
    log(f"  Database       : {args.db} on {args.host}:{args.port}")
    log(f"  Clinics Filter : {args.clinics if args.clinics else 'ALL CLINICS'}")
    log(f"  Mode           : {'DRY-RUN (SIMULATION ONLY - NO FILES TOUCHED)' if is_dry_run else 'EXECUTE (REAL TRANSFERS)'}")
    log(f"  Operation      : {'COPY (Non-destructive, will NOT overwrite dest)' if copy_mode else 'MOVE (Rename)'}")
    if not is_dry_run:
        log(f"  Parallelism    : {args.workers} worker threads")

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

    # 5. Scan Remote Storage (Source and Dest)
    try:
        source_cache = "rclone_source_cache.txt"
        if not os.path.exists(source_cache) and os.path.exists("rclone_files_cache.txt") and source_remote == DEFAULT_REMOTE:
            source_cache = "rclone_files_cache.txt"

        source_files = get_remote_file_list(rclone_exe, source_remote, cache_file=source_cache, use_cache=args.use_cache)

        dest_cache = "rclone_dest_cache.txt" if not same_remote else None
        if same_remote:
            dest_files = source_files
        else:
            use_d_cache = args.use_cache and not args.rescan_dest
            dest_files = get_remote_file_list(rclone_exe, dest_remote, cache_file=dest_cache, use_cache=use_d_cache)
    except Exception as e:
        log(f"\n[!] Failed to scan remote storage: {e}")
        sys.exit(1)

    # 6. Build Migration Plan
    actions, stats = plan_media_migration(
        db_docs,
        source_files=source_files,
        dest_files=dest_files,
        clinics_map=clinics_map,
        same_remote=same_remote,
        copy_mode=copy_mode
    )

    # 7. Print Summary Report
    log("\n" + "=" * 70)
    log("  MIGRATION AUDIT SUMMARY")
    log("=" * 70)
    log(f"  Total DB Documents          : {stats['total_db_docs']:,}")
    log(f"  Already in Dest (Skipped)   : {stats['already_in_dest']:,} ({stats['already_in_dest']/stats['total_db_docs']*100:.1f}%) [WILL NOT OVERWRITE]")
    log(f"  Ready to {'Copy' if copy_mode else 'Move'}               : {stats['ready_to_transfer']:,} ({stats['ready_to_transfer']/stats['total_db_docs']*100:.1f}%)")
    log(f"  Missing in Source (Skipped) : {stats['skipped_not_found']:,} ({stats['skipped_not_found']/stats['total_db_docs']*100:.1f}%) [CAN RE-RUN NEXT TIME]")

    log("\n  Breakdown by Clinic:")
    for c_name, c_stat in stats["by_clinic"].items():
        log(f"    - {c_name:12}: {c_stat['already_in_dest']:,} already in dest, {c_stat['transfer']:,} ready to transfer, {c_stat['skipped_not_found']:,} not found in source")

    # Sample Planned Transfers
    transfers = [a for a in actions if a["status"] in ("COPY", "MOVE")]
    if transfers:
        log(f"\n  Sample Planned Transfers (showing first 10 of {len(transfers):,}):")
        for m in transfers[:10]:
            log(f"    [{m['clinic']}] {m['source_path']}  --->  {m['target_path']}")

    # 8. Export CSV Report
    export_plan_csv(actions, args.csv)

    # 9. Execute or Stop
    if is_dry_run:
        log("\n" + "=" * 70)
        log("  DRY-RUN COMPLETE — NO FILES WERE COPIED OR MODIFIED.")
        log(f"  Review '{args.csv}' to inspect every planned transfer.")
        log("  When ready to execute, re-run with: --execute")
        log("=" * 70)
    else:
        if transfers:
            execute_moves(rclone_exe, source_remote, dest_remote, actions, copy_mode=copy_mode, max_workers=args.workers, dest_cache=dest_cache)
        else:
            log("\nNo files need to be transferred. All available files are already at destination!")


if __name__ == "__main__":
    main()

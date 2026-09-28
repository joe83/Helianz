#!/usr/bin/env python3
"""
seed_patient_storage.py - Helianz Cloud Storage Patient Folder Pre-seeder (Fast Batch)
====================================================================================
Creates placeholder (.keep) files in cloud storage (S3 / SFTP via rclone)
for all patients in the database that don't have a folder yet.

Uses high-speed batch upload via a single native rclone copy operation.

Usage:
    python seed_patient_storage.py [OPTIONS]

Options:
    --remote REMOTE        Target rclone remote folder (default: from .env)
    --db DBNAME            Database name (default: from .env)
    --host HOST            Database host (default: from .env)
    --port PORT            Database port (default: from .env)
    --user USER            Database user (default: from .env)
    --password PASS        Database password
    --rclone PATH          Custom path to rclone executable
    --transfers NUM        Number of parallel file transfers (default: 32)
    --use-cache            Use local rclone cache file if available
    --dry-run              Preview actions without creating files
    --env-file FILE        Path to .env file
"""

import sys
import os
import argparse
import subprocess
import tempfile
import atexit
import time
import shutil

try:
    import pymysql
    import pymysql.cursors
    HAS_PYMYSQL = True
except ImportError:
    HAS_PYMYSQL = False

try:
    import mysql.connector
    HAS_MYSQL_CONNECTOR = True
except ImportError:
    HAS_MYSQL_CONNECTOR = False


def log(msg):
    timestamp = time.strftime("%Y-%m-%d %H:%M:%S")
    print(f"[{timestamp}] {msg}", flush=True)


def load_env(env_path):
    config = {}
    if not os.path.exists(env_path):
        return config
    with open(env_path, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            if "=" in line:
                k, v = line.split("=", 1)
                config[k.strip()] = v.strip().strip("'\"")
    return config


def find_rclone_exe(custom_path=None):
    if custom_path and os.path.exists(custom_path):
        return custom_path
    script_dir = os.path.dirname(os.path.abspath(__file__))
    candidates = [
        os.path.join(script_dir, "rclone.exe"),
        os.path.join(script_dir, "rclone"),
        os.path.join(os.getcwd(), "rclone.exe"),
        r"D:\Project\Dental\Helianz\Migration\MultiClinicMerge\rclone.exe",
        "rclone",
        "rclone.exe",
        r"C:\Program Files\Helianz\rclone\rclone.exe",
        r"C:\Program Files (x86)\Helianz\rclone\rclone.exe"
    ]
    for c in candidates:
        if os.path.exists(c):
            return c
    import shutil
    which = shutil.which("rclone")
    if which:
        return which
    return None


_TEMP_RCLONE_CONFIG = None

def setup_rclone_config(env):
    global _TEMP_RCLONE_CONFIG
    access_key = env.get("S3_ACCESS_KEY") or os.environ.get("S3_ACCESS_KEY")
    secret_key = env.get("S3_SECRET_KEY") or os.environ.get("S3_SECRET_KEY")
    provider = env.get("S3_PROVIDER", "IDrive")
    endpoint = env.get("S3_ENDPOINT", "s3.ap-northeast-1.idrivee2.com")
    region = env.get("S3_REGION", "ap-northeast-1")
    remote_name = env.get("RCLONE_REMOTE_NAME", "helianz-media").strip()

    if not access_key or not secret_key:
        return None

    conf_content = f"""[{remote_name}]
type = s3
provider = {provider}
access_key_id = {access_key}
secret_access_key = {secret_key}
endpoint = {endpoint}
region = {region}
acl = private
force_path_style = true
env_auth = false
"""
    with tempfile.NamedTemporaryFile("w", delete=False, suffix="_rclone.conf", encoding="utf-8") as f:
        f.write(conf_content)
        _TEMP_RCLONE_CONFIG = f.name

    os.environ["RCLONE_CONFIG"] = _TEMP_RCLONE_CONFIG

    @atexit.register
    def cleanup():
        global _TEMP_RCLONE_CONFIG
        if _TEMP_RCLONE_CONFIG and os.path.exists(_TEMP_RCLONE_CONFIG):
            try:
                os.remove(_TEMP_RCLONE_CONFIG)
            except Exception:
                pass
            _TEMP_RCLONE_CONFIG = None

    return _TEMP_RCLONE_CONFIG


def get_db_connection(host, port, user, password, database):
    if HAS_PYMYSQL:
        return pymysql.connect(
            host=host,
            port=int(port),
            user=user,
            password=password,
            database=database,
            charset="utf8mb4",
            cursorclass=pymysql.cursors.DictCursor
        )
    elif HAS_MYSQL_CONNECTOR:
        return mysql.connector.connect(
            host=host,
            port=int(port),
            user=user,
            password=password,
            database=database
        )
    else:
        raise RuntimeError("No MySQL driver available. Please install pymysql (`pip install pymysql`).")


def fetch_all_patients(conn):
    cursor = conn.cursor()
    cursor.execute("SELECT PatNum FROM patient ORDER BY PatNum ASC")
    rows = cursor.fetchall()
    cursor.close()
    if isinstance(rows[0] if rows else None, dict):
        return [r["PatNum"] for r in rows]
    else:
        return [r[0] for r in rows]


def get_existing_remote_dirs(rclone_exe, remote_base, config_file=None, cache_file=None, use_cache=False):
    """Scan or load existing patient directories in remote storage."""
    script_dir = os.path.dirname(os.path.abspath(__file__))
    candidates = [
        cache_file,
        os.path.join(script_dir, "rclone_dest_cache.txt"),
        os.path.join(script_dir, "rclone_files_cache.txt")
    ]
    if use_cache:
        for c in candidates:
            if c and os.path.exists(c):
                log(f"Loading existing remote files from cache: '{c}' ...")
                existing = set()
                with open(c, "r", encoding="utf-8", errors="replace") as f:
                    for line in f:
                        parts = line.strip().strip("/").split("/")
                        if len(parts) >= 2:
                            try:
                                existing.add(int(parts[1]))
                            except ValueError:
                                pass
                log(f"Loaded {len(existing):,} existing patient folders from cache.")
                return existing

    log(f"Scanning remote storage: '{remote_base}' (takes ~30-45s) ...")
    cmd = [rclone_exe, "lsf", remote_base, "--dirs-only", "--max-depth", "2", "--fast-list"]
    if config_file:
        cmd.extend(["--config", config_file])

    proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, encoding="utf-8", errors="replace")
    out, err = proc.communicate()
    if proc.returncode != 0 and "directory not found" not in err.lower():
        log(f"Warning scanning remote: {err.strip()}")
        return set()

    existing_folders = set()
    for line in out.splitlines():
        line = line.strip().strip("/")
        if not line:
            continue
        parts = line.split("/")
        if len(parts) >= 2:
            try:
                pat_num = int(parts[1])
                existing_folders.add(pat_num)
            except ValueError:
                pass
    log(f"Found {len(existing_folders):,} existing patient folders in remote storage.")
    return existing_folders


def main():
    parser = argparse.ArgumentParser(description="Fast batch seed of missing patient storage folders in S3.")
    parser.add_argument("--remote", default=None, help="Remote path (e.g. 'helianz-media:dsmile/HelianzImages')")
    parser.add_argument("--db", default=None, help="Database name")
    parser.add_argument("--host", default=None, help="Database host")
    parser.add_argument("--port", default=None, type=int, help="Database port")
    parser.add_argument("--user", default=None, help="Database user")
    parser.add_argument("--password", default=None, help="Database password")
    parser.add_argument("--rclone", default=None, help="Path to rclone executable")
    parser.add_argument("--transfers", default=32, type=int, help="Parallel rclone transfers (default: 32)")
    parser.add_argument("--dry-run", action="store_true", help="Preview without creating files")
    parser.add_argument("--use-cache", action="store_true", help="Use local cache file if present")
    parser.add_argument("--env-file", default=None, help="Path to .env file")
    parser.add_argument("--local-dir", default=None, help="Target local directory to create folders in without copying to remote")
    parser.add_argument("--local-only", action="store_true", help="Only create local folders and do not copy to remote")
    parser.add_argument("--limit", default=0, type=int, help="Limit number of patients to process (for testing)")
    parser.add_argument("--all", action="store_true", help="Seed all patients without checking remote first")

    args = parser.parse_args()

    # Locate .env
    script_dir = os.path.dirname(os.path.abspath(__file__))
    env_file = args.env_file or os.path.join(script_dir, ".env")
    env = load_env(env_file)

    remote_base = args.remote or env.get("DEFAULT_REMOTE", "helianz-media:dsmile/HelianzImages")
    db_name = args.db or env.get("MYSQL_DATABASE", "helianz")
    db_host = args.host or env.get("MYSQL_HOST", "localhost")
    db_port = args.port or int(env.get("MYSQL_PORT", 3306))
    db_user = args.user or env.get("MYSQL_USER", "root")
    db_pass = args.password or env.get("MYSQL_PASSWORD", "")

    log("=" * 60)
    log("HELIANZ CLOUD STORAGE PATIENT FOLDER SEEDER")
    log("=" * 60)
    log(f"Database      : {db_user}@{db_host}:{db_port}/{db_name}")
    if args.local_dir or args.local_only:
        target_local = args.local_dir or os.path.join(script_dir, "local_patient_folders_preview")
        log(f"Mode          : LOCAL ONLY (No remote copy)")
        log(f"Local Target  : {target_local}")
    else:
        log(f"Target Remote : {remote_base}")
        log(f"Transfers     : {args.transfers}")
        log(f"Dry-Run Mode  : {'YES (No files will be created)' if args.dry_run else 'NO'}")

    rclone_exe = find_rclone_exe(args.rclone)

    # Connect to DB
    try:
        conn = get_db_connection(db_host, db_port, db_user, db_pass, db_name)
        pat_nums = fetch_all_patients(conn)
        conn.close()
        log(f"Total Patients in Database: {len(pat_nums):,}")
    except Exception as ex:
        log(f"ERROR connecting to database: {ex}")
        sys.exit(1)

    if not pat_nums:
        log("No patients found in database. Exiting.")
        sys.exit(0)

    if args.limit > 0:
        pat_nums = pat_nums[:args.limit]
        log(f"Limiting to first {len(pat_nums):,} patients.")

    # If Local-Only Mode
    if args.local_dir or args.local_only:
        target_local = args.local_dir or os.path.join(script_dir, "local_patient_folders_preview")
        os.makedirs(target_local, exist_ok=True)
        log(f"Creating local folders for {len(pat_nums):,} patients in '{target_local}'...")
        start_time = time.time()
        marker_content = "Helianz Folder Marker\n"

        for p in pat_nums:
            bucket = str(p % 100)
            p_dir = os.path.join(target_local, bucket, str(p))
            os.makedirs(p_dir, exist_ok=True)
            keep_path = os.path.join(p_dir, ".keep")
            with open(keep_path, "w", encoding="utf-8") as f:
                f.write(marker_content)

        elapsed = time.time() - start_time
        log("=" * 60)
        log(f"SUCCESS! Created {len(pat_nums):,} patient folders locally in {elapsed:.2f}s.")
        log(f"Location: {os.path.abspath(target_local)}")
        log("Sample folders created:")
        for p in pat_nums[:10]:
            bucket = str(p % 100)
            print(f"  [DIR] {os.path.join(os.path.abspath(target_local), bucket, str(p))}\\.keep")
        if len(pat_nums) > 10:
            print(f"  ... and {len(pat_nums) - 10:,} more.")
        log("=" * 60)
        sys.exit(0)

    if not rclone_exe:
        log("ERROR: rclone executable not found! Place rclone.exe in script directory or specify --rclone.")
        sys.exit(1)

    config_file = setup_rclone_config(env)
    if config_file:
        log("Rclone Config : Generated dynamically from S3 credentials")

    # Determine missing patient folders
    if args.all:
        missing_pats = pat_nums
    else:
        existing_pats = get_existing_remote_dirs(rclone_exe, remote_base, config_file, use_cache=args.use_cache)
        missing_pats = [p for p in pat_nums if p not in existing_pats]

    log(f"Patients needing remote folder marker: {len(missing_pats):,}")

    if not missing_pats:
        log("[OK] All patient folders are already present in remote storage!")
        sys.exit(0)

    if args.dry_run:
        log(f"[DRY-RUN] Would create .keep markers for {len(missing_pats):,} patients.")
        for p in missing_pats[:10]:
            bucket = p % 100
            print(f"  - {remote_base}/{bucket}/{p}/.keep")
        if len(missing_pats) > 10:
            print(f"  ... and {len(missing_pats) - 10:,} more.")
        sys.exit(0)

    # Step 1: Prepare local directory structure in a temporary staging folder
    staging_dir = os.path.join(tempfile.gettempdir(), "helianz_seed_staging")
    if os.path.exists(staging_dir):
        shutil.rmtree(staging_dir, ignore_errors=True)
    os.makedirs(staging_dir, exist_ok=True)

    log(f"Building local staging folder structure for {len(missing_pats):,} patients...")
    build_start = time.time()
    marker_content = "Helianz Folder Marker\n"

    for p in missing_pats:
        bucket = str(p % 100)
        p_dir = os.path.join(staging_dir, bucket, str(p))
        os.makedirs(p_dir, exist_ok=True)
        keep_path = os.path.join(p_dir, ".keep")
        with open(keep_path, "w", encoding="utf-8") as f:
            f.write(marker_content)

    log(f"Staging structure created in {time.time() - build_start:.2f}s.")

    # Step 2: Single High-Speed Rclone Batch Copy
    log(f"Uploading all {len(missing_pats):,} folders to remote in parallel (Transfers={args.transfers})...")
    upload_start = time.time()

    cmd = [
        rclone_exe, "copy", staging_dir, remote_base,
        "--transfers", str(args.transfers),
        "--checkers", str(args.transfers),
        "--fast-list",
        "--stats", "3s",
        "--stats-one-line",
        "-P"
    ]
    if config_file:
        cmd.extend(["--config", config_file])

    proc = subprocess.Popen(cmd)
    proc.communicate()

    # Cleanup staging directory
    try:
        shutil.rmtree(staging_dir, ignore_errors=True)
    except Exception:
        pass

    total_time = time.time() - upload_start
    if proc.returncode == 0:
        log("=" * 60)
        log(f"SUCCESS! Provisioned {len(missing_pats):,} patient folders in {total_time:.1f}s.")
        log("=" * 60)
    else:
        log(f"ERROR: rclone exited with code {proc.returncode}")
        sys.exit(proc.returncode)


if __name__ == "__main__":
    main()

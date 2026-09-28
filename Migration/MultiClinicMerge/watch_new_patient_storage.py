#!/usr/bin/env python3
"""
watch_new_patient_storage.py - Helianz Cloud Storage Patient Folder Watcher
==========================================================================
Monitors the database for new patients and automatically creates their
placeholder (.keep) in cloud storage (S3 / SFTP via rclone).

Can run:
1. In continuous loop / daemon mode (default: checks every 60s)
2. As a single-pass job (--once) suitable for Windows Task Scheduler / cron.

Usage:
    python watch_new_patient_storage.py [OPTIONS]

Options:
    --interval SECONDS     Check interval in seconds when in daemon mode (default: 60)
    --once                 Run a single check pass and exit (for Task Scheduler)
    --remote REMOTE        Target rclone remote (default: from .env)
    --db DBNAME            Database name
    --host HOST            Database host
    --port PORT            Database port
    --user USER            Database user
    --password PASS        Database password
    --rclone PATH          Path to rclone executable
    --env-file FILE        Path to .env file
"""

import sys
import os
import argparse
import subprocess
import tempfile
import atexit
import time

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


def create_placeholder_file():
    temp_dir = tempfile.gettempdir()
    keep_file = os.path.join(temp_dir, "helianz_keep.txt")
    if not os.path.exists(keep_file):
        with open(keep_file, "w", encoding="utf-8") as f:
            f.write("Helianz Patient Folder Marker\n")
    return keep_file


def upload_placeholder(rclone_exe, placeholder_path, remote_dest, config_file=None):
    cmd = [rclone_exe, "copyto", placeholder_path, remote_dest]
    if config_file:
        cmd.extend(["--config", config_file])
    proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, encoding="utf-8", errors="replace")
    out, err = proc.communicate()
    return proc.returncode == 0, err


def check_and_seed_new_patients(conn, rclone_exe, remote_base, config_file, placeholder_file, state_file):
    # Read last known maximum PatNum from state file
    last_max_patnum = 0
    if os.path.exists(state_file):
        try:
            with open(state_file, "r") as f:
                last_max_patnum = int(f.read().strip())
        except Exception:
            last_max_patnum = 0

    cursor = conn.cursor()
    if last_max_patnum > 0:
        cursor.execute("SELECT PatNum FROM patient WHERE PatNum > %s ORDER BY PatNum ASC", (last_max_patnum,))
    else:
        # First run: get all recent patients or max
        cursor.execute("SELECT PatNum FROM patient ORDER BY PatNum ASC")
    
    rows = cursor.fetchall()
    cursor.close()

    if not rows:
        return 0, last_max_patnum

    pat_nums = [r["PatNum"] if isinstance(r, dict) else r[0] for r in rows]
    remote_base_clean = remote_base.rstrip("/")

    log(f"Found {len(pat_nums)} new patient(s) to provision in cloud storage: PatNums {pat_nums[:5]}...")

    created = 0
    for p in pat_nums:
        bucket = p % 100
        dest = f"{remote_base_clean}/{bucket}/{p}/.keep"
        ok, err = upload_placeholder(rclone_exe, placeholder_file, dest, config_file)
        if ok:
            created += 1
            if p > last_max_patnum:
                last_max_patnum = p
        else:
            log(f"Failed creating remote folder for PatNum {p}: {err.strip()}")

    # Save state
    try:
        with open(state_file, "w") as f:
            f.write(str(last_max_patnum))
    except Exception as ex:
        log(f"Warning saving state file: {ex}")

    return created, last_max_patnum


def main():
    parser = argparse.ArgumentParser(description="Watch for new patients and automatically provision S3 folders.")
    parser.add_argument("--interval", default=60, type=int, help="Polling interval in seconds (default: 60)")
    parser.add_argument("--once", action="store_true", help="Run a single pass and exit (for Task Scheduler)")
    parser.add_argument("--remote", default=None, help="Remote path (e.g. 'helianz-media:dsmile/HelianzImages')")
    parser.add_argument("--db", default=None, help="Database name")
    parser.add_argument("--host", default=None, help="Database host")
    parser.add_argument("--port", default=None, type=int, help="Database port")
    parser.add_argument("--user", default=None, help="Database user")
    parser.add_argument("--password", default=None, help="Database password")
    parser.add_argument("--rclone", default=None, help="Path to rclone executable")
    parser.add_argument("--env-file", default=None, help="Path to .env file")

    args = parser.parse_args()

    script_dir = os.path.dirname(os.path.abspath(__file__))
    env_file = args.env_file or os.path.join(script_dir, ".env")
    env = load_env(env_file)

    remote_base = args.remote or env.get("DEFAULT_REMOTE", "helianz-media:dsmile/HelianzImages")
    db_name = args.db or env.get("MYSQL_DATABASE", "helianz")
    db_host = args.host or env.get("MYSQL_HOST", "localhost")
    db_port = args.port or int(env.get("MYSQL_PORT", 3306))
    db_user = args.user or env.get("MYSQL_USER", "root")
    db_pass = args.password or env.get("MYSQL_PASSWORD", "")

    state_file = os.path.join(script_dir, ".patient_watch_state.txt")
    placeholder_file = create_placeholder_file()

    rclone_exe = find_rclone_exe(args.rclone)
    if not rclone_exe:
        log("ERROR: rclone executable not found!")
        sys.exit(1)

    config_file = setup_rclone_config(env)

    log("=" * 60)
    log("HELIANZ PATIENT STORAGE WATCHER")
    log("=" * 60)
    log(f"Remote Path   : {remote_base}")
    log(f"Database      : {db_user}@{db_host}:{db_port}/{db_name}")
    log(f"Mode          : {'Single-pass' if args.once else f'Continuous daemon (every {args.interval}s)'}")

    if args.once:
        try:
            conn = get_db_connection(db_host, db_port, db_user, db_pass, db_name)
            created, max_p = check_and_seed_new_patients(conn, rclone_exe, remote_base, config_file, placeholder_file, state_file)
            conn.close()
            log(f"Pass complete. Provisioned: {created} new folders (Max PatNum: {max_p}).")
        except Exception as ex:
            log(f"Error during check: {ex}")
            sys.exit(1)
        sys.exit(0)

    # Daemon loop
    log("Watcher daemon started. Press Ctrl+C to stop.")
    while True:
        try:
            conn = get_db_connection(db_host, db_port, db_user, db_pass, db_name)
            created, max_p = check_and_seed_new_patients(conn, rclone_exe, remote_base, config_file, placeholder_file, state_file)
            conn.close()
            if created > 0:
                log(f"Provisioned {created} new folder(s). Current max PatNum: {max_p}")
        except KeyboardInterrupt:
            log("Watcher stopped by user.")
            break
        except Exception as ex:
            log(f"Error checking patients: {ex}")

        time.sleep(args.interval)


if __name__ == "__main__":
    main()

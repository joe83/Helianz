"""
Dynamic Multi-Clinic Merge Automation Script
=============================================
Fully parameterized tool to merge independent clinic databases into a centralized multi-clinic database.

Features:
  - No hardcoded database names or credentials
  - Database names, user, host, port, and autoinc start passed as CLI parameters or interactive prompts
  - Secure password prompt dialog via getpass if password is not supplied on CLI
  - Auto-detection of MariaDB/MySQL bin directory
  - Supports any number of clinics (Clinic 1 as base, subsequent clinics offset & merged sequentially)
  - Dynamic rounding-up offset formula: ceil(target_max_pk / step) * step
  - Post-merge workstation deduplication (computerpref)
  - Dynamic user deduplication & foreign-key remapping across all tables
  - Post-merge preference deduplication
  - Comprehensive referential integrity verification

Usage Examples:
  # Fully parameterized command line:
  python merge_mysql_clinics.py --target helianz --sources helianz_klt,helianz_byl,helianz_jog -u root

  # Interactive mode (prompts for databases, user, and password):
  python merge_mysql_clinics.py

  # Dry-run preview:
  python merge_mysql_clinics.py --target helianz --sources helianz_klt,helianz_byl,helianz_jog -u root --dry-run
"""

import os
import sys
import math
import time
import shutil
import getpass
import argparse
import subprocess
from datetime import datetime

def find_repo_root(start_dir):
    cur = os.path.abspath(start_dir)
    while True:
        if os.path.exists(os.path.join(cur, ".venv")) or os.path.exists(os.path.join(cur, "Helianz.sln")):
            return cur
        parent = os.path.dirname(cur)
        if parent == cur:
            break
        cur = parent
    return os.path.dirname(os.path.dirname(os.path.abspath(start_dir)))

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
if SCRIPT_DIR not in sys.path:
    sys.path.insert(0, SCRIPT_DIR)
REPO_ROOT = find_repo_root(SCRIPT_DIR)
BACKUP_DIR = os.path.join(SCRIPT_DIR, "Backups")

# Auto-detect and switch to project virtual environment if mysql.connector is missing
try:
    import mysql.connector
except ImportError:
    _venv_python = os.path.join(REPO_ROOT, ".venv", "Scripts", "python.exe")
    if os.path.exists(_venv_python) and os.path.normpath(sys.executable).lower() != os.path.normpath(_venv_python).lower():
        # Transparently re-launch this script using the venv Python
        _result = subprocess.run([_venv_python] + sys.argv)
        sys.exit(_result.returncode)
    else:
        _venv_site = os.path.join(REPO_ROOT, ".venv", "Lib", "site-packages")
        if os.path.exists(_venv_site) and _venv_site not in sys.path:
            sys.path.insert(0, _venv_site)
        try:
            import mysql.connector
        except ImportError:
            sys.exit(
                "Error: 'mysql-connector-python' is not installed in the active Python environment.\n"
                f"Please run with the project virtual environment:\n"
                f"  {_venv_python} {' '.join(sys.argv)}\n"
                f"Or use the PowerShell wrapper:\n"
                f"  .\\Merge-ClinicsProduction.ps1 ...\n"
            )

# Ensure UTF-8 output on Windows console
if sys.platform == "win32":
    try:
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
        sys.stderr.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass

# Tools in Migration/MultiClinicMerge folder
SEGREGATE_SCRIPT = os.path.join(SCRIPT_DIR, "segregate_clinic.py")
OFFSET_SCRIPT = os.path.join(SCRIPT_DIR, "offset_db.py")
MERGE_SCRIPT = os.path.join(SCRIPT_DIR, "merge_clinics.py")
AUTOINC_SCRIPT = os.path.join(SCRIPT_DIR, "set_autoinc.py")
CALC_OFFSET_SCRIPT = os.path.join(SCRIPT_DIR, "calc_offset.py")

DEFAULT_STEP = 1_000_000
DEFAULT_AUTOINC = 10_000_000

COMMON_BIN_PATHS = [
    r"C:\Program Files\MariaDB 10.5\bin",
    r"C:\Program Files\MariaDB 10.6\bin",
    r"C:\Program Files\MariaDB 10.11\bin",
    r"C:\Program Files\MariaDB 11.0\bin",
    r"C:\Program Files\MySQL\MySQL Server 8.0\bin",
]


import socket

DEBUG = True

def debug_log(msg):
    if DEBUG:
        now = datetime.now().strftime("%H:%M:%S.%f")[:-3]
        print(f"[{now}] [DEBUG] {msg}", flush=True)


def log_header(title):
    print("\n" + "=" * 70, flush=True)
    print(f"  {title}", flush=True)
    print("=" * 70, flush=True)


def log_step(step, title):
    print(f"\n--- [{step}] {title} ---", flush=True)


def find_mariadb_bin(user_supplied=None):
    """Locate directory containing mysql.exe and mysqldump.exe."""
    debug_log(f"find_mariadb_bin: user_supplied='{user_supplied}'")
    if user_supplied and os.path.isdir(user_supplied):
        if os.path.exists(os.path.join(user_supplied, "mysql.exe")):
            debug_log(f"find_mariadb_bin: Found in user_supplied: {user_supplied}")
            return user_supplied

    env_bin = os.environ.get("MARIADB_BIN") or os.environ.get("MYSQL_BIN")
    if env_bin and os.path.isdir(env_bin) and os.path.exists(os.path.join(env_bin, "mysql.exe")):
        debug_log(f"find_mariadb_bin: Found in env var: {env_bin}")
        return env_bin

    for path in COMMON_BIN_PATHS:
        debug_log(f"find_mariadb_bin: Checking common path '{path}'...")
        if os.path.isdir(path) and os.path.exists(os.path.join(path, "mysql.exe")):
            debug_log(f"find_mariadb_bin: Found in common path: {path}")
            return path

    which_mysql = shutil.which("mysql")
    if which_mysql:
        found_dir = os.path.dirname(which_mysql)
        debug_log(f"find_mariadb_bin: Found in PATH via which: {found_dir}")
        return found_dir

    debug_log("find_mariadb_bin: No MariaDB/MySQL bin directory found.")
    return None


def get_mysql_conn(host, port, user, password, db=None, timeout=10):
    """
    Connect to MariaDB / MySQL with a strict connection timeout and
    automatic IPv4/localhost fallback to avoid Windows IPv6 resolution hangs.
    """
    debug_log(f"get_mysql_conn called: host='{host}', port={port}, user='{user}', db='{db}', timeout={timeout}s")

    # Set default socket timeout so NO socket call anywhere can hang indefinitely
    socket.setdefaulttimeout(float(timeout))

    # Resolve host via getaddrinfo to see exactly what IP addresses are returned
    try:
        addrinfos = socket.getaddrinfo(host, port, 0, socket.SOCK_STREAM)
        resolved_ips = [ai[4][0] for ai in addrinfos]
        debug_log(f"DNS/socket getaddrinfo for '{host}:{port}' -> {resolved_ips}")
    except Exception as err:
        debug_log(f"DNS/socket getaddrinfo failed for '{host}:{port}': {err}")

    hosts_to_try = [host]
    if host.lower() in ("localhost", "127.0.0.1"):
        # Favor 127.0.0.1 first on Windows to bypass IPv6 (::1) socket hangs, then try localhost
        hosts_to_try = ["127.0.0.1", "localhost"]
        try:
            local_ip = socket.gethostbyname(socket.gethostname())
            if local_ip not in hosts_to_try and not local_ip.startswith("127."):
                hosts_to_try.append(local_ip)
        except Exception:
            pass

    debug_log(f"Candidate hosts to attempt in order: {hosts_to_try}")

    last_err = None
    for h in hosts_to_try:
        # Step A: Raw TCP socket probe to verify port is open and receiving greetings
        debug_log(f"Probing raw TCP socket on {h}:{port} (timeout=3.0s)...")
        family = socket.AF_INET6 if ":" in h else socket.AF_INET
        s = socket.socket(family, socket.SOCK_STREAM)
        s.settimeout(3.0)
        sock_err = s.connect_ex((h, port))
        if sock_err != 0:
            debug_log(f"[!] Raw TCP socket connect to {h}:{port} returned error code {sock_err} (10061 = Connection Refused, service may be stopped or listening on different port)")
            s.close()
            continue
        else:
            debug_log(f"[OK] Raw TCP socket connected to {h}:{port}. Waiting up to 3s for MariaDB greeting...")
            try:
                greeting = s.recv(1024)
                debug_log(f"[OK] Server greeting received ({len(greeting)} bytes): {greeting[:40]}")
            except Exception as ge:
                debug_log(f"[!] Warning: TCP connected, but server greeting timed out: {ge} (MariaDB might be blocked on reverse DNS or max_connections)")
            s.close()

        # Step B: mysql.connector connection attempts (with ssl_disabled and use_pure)
        for use_pure in [True, False]:
            debug_log(f"Attempting mysql.connector.connect(host='{h}', port={port}, user='{user}', timeout={timeout}s, ssl_disabled=True, use_pure={use_pure})...")
            kwargs = {
                "host": h,
                "port": port,
                "user": user,
                "password": password,
                "charset": "utf8mb4",
                "connection_timeout": timeout,
                "ssl_disabled": True,
                "use_pure": use_pure,
            }
            if db:
                kwargs["database"] = db

            t0 = time.time()
            try:
                conn = mysql.connector.connect(**kwargs)
                elapsed = time.time() - t0
                server_ver = getattr(conn, "server_info", None) or "unknown"
                thread_id = getattr(conn, "connection_id", "n/a")
                debug_log(f"[OK] Connected to '{h}:{port}' in {elapsed:.3f}s (Server: {server_ver}, Thread ID: {thread_id})")
                return conn
            except Exception as e:
                elapsed = time.time() - t0
                debug_log(f"[!] Connection attempt (use_pure={use_pure}) to '{h}:{port}' failed after {elapsed:.3f}s: {type(e).__name__}: {e}")
                last_err = e

    raise last_err


NTSTATUS_NAMES = {
    3221225477: "STATUS_ACCESS_VIOLATION (0xC0000005 - memory access violation/segfault)",
    3221225786: "STATUS_CONTROL_C_EXIT (0xC000013A)",
    3221225478: "STATUS_IN_PAGE_ERROR (0xC0000006)",
    3221225620: "STATUS_INTEGER_DIVIDE_BY_ZERO (0xC0000094)",
    3221225725: "STATUS_STACK_OVERFLOW (0xC00000FD)",
    3221226505: "STATUS_DLL_NOT_FOUND (0xC0000135)",
}


class SimpleProcResult:
    def __init__(self, returncode, stdout="", stderr=""):
        self.returncode = returncode
        self.stdout = stdout
        self.stderr = stderr


def run_shell_cmd(cmd, env_vars=None, check=True, print_stdout=False):
    debug_log(f"run_shell_cmd: Executing: {cmd}")
    env = os.environ.copy()
    env["PYTHONIOENCODING"] = "utf-8"
    env["PYTHONUNBUFFERED"] = "1"
    if env_vars:
        env.update(env_vars)

    t0 = time.time()
    if print_stdout:
        # Stream live output so the user sees real-time progress
        proc = subprocess.Popen(
            cmd,
            shell=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
            env=env,
            encoding="utf-8",
            errors="replace",
        )
        lines = []
        for line in iter(proc.stdout.readline, ""):
            print(line, end="", flush=True)
            lines.append(line)
        proc.stdout.close()
        proc.wait()
        elapsed = time.time() - t0
        debug_log(f"run_shell_cmd: Completed in {elapsed:.2f}s (Exit code: {proc.returncode})")
        if proc.returncode != 0 and check:
            crash_note = NTSTATUS_NAMES.get(proc.returncode, "")
            last_lines = "".join(lines[-10:]).strip()
            err_msg = crash_note if not last_lines else f"{last_lines}\n{crash_note}".strip()
            raise RuntimeError(f"Command failed (exit {proc.returncode}): {cmd}\nError: {err_msg}")
        return SimpleProcResult(proc.returncode, "".join(lines))
    else:
        proc = subprocess.run(
            cmd, shell=True, capture_output=True, text=True, env=env, encoding="utf-8", errors="replace"
        )
        elapsed = time.time() - t0
        debug_log(f"run_shell_cmd: Completed in {elapsed:.2f}s (Exit code: {proc.returncode})")
        if proc.stdout:
            debug_log(f"run_shell_cmd stdout ({len(proc.stdout)} chars): {proc.stdout.strip()[:200]}")
        if proc.stderr:
            debug_log(f"run_shell_cmd stderr ({len(proc.stderr)} chars): {proc.stderr.strip()[:200]}")
        if proc.returncode != 0 and check:
            crash_note = NTSTATUS_NAMES.get(proc.returncode, "")
            err_msg = proc.stderr.strip() or proc.stdout.strip() or crash_note
            raise RuntimeError(f"Command failed (exit {proc.returncode}): {cmd}\nError: {err_msg}")
        return proc


def get_python_exe():
    venv_py = os.path.join(REPO_ROOT, ".venv", "Scripts", "python.exe")
    if os.path.exists(venv_py):
        return venv_py
    return sys.executable


def get_max_pk_in_db(conn, db_name):
    """
    Fast discovery of maximum primary key in the specified database.
    Uses information_schema.TABLES AUTO_INCREMENT metadata first, then verifies
    actual MAX() on top candidate tables. Finishes in ~0.1s instead of running 390+ queries.
    """
    debug_log(f"get_max_pk_in_db: Starting max PK scan for `{db_name}`...")
    t0 = time.time()
    cursor = conn.cursor()
    cursor.execute("""
        SELECT TABLE_NAME, AUTO_INCREMENT 
        FROM information_schema.TABLES 
        WHERE TABLE_SCHEMA = %s AND AUTO_INCREMENT IS NOT NULL
        ORDER BY AUTO_INCREMENT DESC
    """, (db_name,))
    table_autoincs = cursor.fetchall()
    debug_log(f"get_max_pk_in_db: Found {len(table_autoincs)} auto_increment tables in `{db_name}` ({time.time()-t0:.3f}s)")

    overall_max = 0
    top_details = []

    if table_autoincs:
        # Check actual MAX() on top 15 candidate tables with largest auto_increment
        top_candidates = table_autoincs[:15]
        debug_log(f"get_max_pk_in_db: Checking top {len(top_candidates)} candidate tables...")
        for tbl, ai in top_candidates:
            if ai and ai > 1:
                try:
                    cursor.execute("""
                        SELECT COLUMN_NAME FROM information_schema.COLUMNS 
                        WHERE TABLE_SCHEMA = %s AND TABLE_NAME = %s AND EXTRA LIKE '%%auto_increment%%'
                        LIMIT 1
                    """, (db_name, tbl))
                    col_row = cursor.fetchone()
                    if col_row:
                        col = col_row[0]
                        cursor.execute(f"SELECT MAX(`{col}`) FROM `{db_name}`.`{tbl}`")
                        r = cursor.fetchone()
                        val = r[0] if (r and r[0] is not None) else (ai - 1)
                        debug_log(f"get_max_pk_in_db: `{db_name}`.`{tbl}`.`{col}` -> MAX = {val}")
                        if val > overall_max:
                            overall_max = val
                        if val > 0:
                            top_details.append((tbl, col, val))
                except Exception as e:
                    debug_log(f"get_max_pk_in_db: Query failed on `{tbl}`: {e}")

    # Fallback to column scan if no table metadata found
    if overall_max == 0:
        debug_log(f"get_max_pk_in_db: Fallback to full column scan on `{db_name}`...")
        cursor.execute("""
            SELECT TABLE_NAME, COLUMN_NAME FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = %s AND EXTRA LIKE '%%auto_increment%%'
              AND DATA_TYPE = 'bigint'
            ORDER BY TABLE_NAME
        """, (db_name,))
        pk_cols = cursor.fetchall()
        for tbl, col in pk_cols:
            try:
                cursor.execute(f"SELECT MAX(`{col}`) FROM `{db_name}`.`{tbl}`")
                row = cursor.fetchone()
                val = row[0] if (row and row[0] is not None) else 0
                if val > overall_max:
                    overall_max = val
                if val > 0:
                    top_details.append((tbl, col, val))
            except Exception:
                pass

    cursor.close()
    top_details.sort(key=lambda x: x[2], reverse=True)
    debug_log(f"get_max_pk_in_db: Final max PK for `{db_name}` = {overall_max:,} (Total time: {time.time()-t0:.3f}s)")
    return overall_max, top_details


def compute_rounded_offset(max_pk, step=DEFAULT_STEP):
    """
    User rule:
      Offset is rounded up to the nearest step based on target's max PK.
      ceil(max_pk / step) * step
    """
    if max_pk <= 0:
        return step
    return math.ceil(max_pk / step) * step


def parse_clinic_definitions(sources_arg, clinics_arg, klt_db=None, byl_db=None, jog_db=None):
    """
    Builds a list of clinic objects:
      [{'ClinicNum': 1, 'db': '...', 'Description': '...', 'Abbr': '...', 'ExternalID': 1}, ...]
    """
    clinics = []

    if clinics_arg:
        # Format: "1:db1:Name 1:ABBR1, 2:db2:Name 2:ABBR2"
        parts = [p.strip() for p in clinics_arg.split(",") if p.strip()]
        for p in parts:
            tokens = [t.strip() for t in p.split(":")]
            c_num = int(tokens[0])
            c_db = tokens[1]
            c_desc = tokens[2] if len(tokens) > 2 else f"Clinic {c_num}"
            c_abbr = tokens[3] if len(tokens) > 3 else f"C{c_num}"
            clinics.append({
                "ClinicNum": c_num,
                "db": c_db,
                "Description": c_desc,
                "Abbr": c_abbr,
                "ExternalID": c_num,
                "TimeZone": "SE Asia Standard Time",
            })
        return clinics

    if sources_arg:
        # Format: "db1,db2,db3..."
        src_dbs = [s.strip() for s in sources_arg.split(",") if s.strip()]
        for i, db in enumerate(src_dbs, start=1):
            # Try to derive nice default name from database name
            name_guess = db.replace("helianz_", "").replace("cdental_", "").replace("_", " ").title()
            abbr_guess = "".join(w[:3].upper() for w in name_guess.split()) + str(i)
            clinics.append({
                "ClinicNum": i,
                "db": db,
                "Description": f"{name_guess} {i}" if not any(c.isdigit() for c in name_guess) else name_guess,
                "Abbr": abbr_guess[:6],
                "ExternalID": i,
                "TimeZone": "SE Asia Standard Time",
            })
        return clinics

    # Fallback to explicit clinic flags if provided
    items = []
    if klt_db:
        items.append((1, klt_db, "Klaten 1", "KLT1"))
    if byl_db:
        items.append((2, byl_db, "Boyolali 1", "BYL1"))
    if jog_db:
        items.append((3, jog_db, "Jogja 1", "JOG1"))

    for c_num, c_db, c_desc, c_abbr in items:
        clinics.append({
            "ClinicNum": c_num,
            "db": c_db,
            "Description": c_desc,
            "Abbr": c_abbr,
            "ExternalID": c_num,
            "TimeZone": "SE Asia Standard Time",
        })

    return clinics


def ensure_clinics_registered(conn, db_name, clinics):
    cursor = conn.cursor()
    cursor.execute(f"USE `{db_name}`")
    for c in clinics:
        cursor.execute(f"""
            INSERT INTO clinic 
                (ClinicNum, Description, Abbr, ExternalID, TimeZone, ItemOrder)
            VALUES 
                ({c['ClinicNum']}, '{c['Description']}', '{c['Abbr']}', {c['ExternalID']}, '{c.get('TimeZone', 'SE Asia Standard Time')}', {c['ClinicNum']})
            ON DUPLICATE KEY UPDATE 
                Description = VALUES(Description),
                Abbr = VALUES(Abbr),
                ExternalID = VALUES(ExternalID),
                TimeZone = VALUES(TimeZone);
        """)
    # Enable clinics in preference
    cursor.execute("""
        UPDATE preference 
        SET ValueString = '0' 
        WHERE PrefName IN ('EasyNoClinics', 'ClinicListIsAlphabetical')
    """)
    conn.commit()
    cursor.close()
    print(f"  [OK] Registered clinics in `{db_name}`")


def apply_post_merge_fixes(conn, target_db, clinics):
    cursor = conn.cursor()
    cursor.execute(f"USE `{target_db}`")

    # 1. ComputerPref: Deduplicate by ComputerName and ensure ApptViewNum != 0
    cursor.execute(f"""
        DELETE cp1 FROM `{target_db}`.`computerpref` cp1
        INNER JOIN `{target_db}`.`computerpref` cp2
        WHERE cp1.ComputerName = cp2.ComputerName AND cp1.ComputerPrefNum > cp2.ComputerPrefNum
    """)
    if cursor.rowcount > 0:
        print(f"  [FIX] Removed {cursor.rowcount} duplicate computerpref entries")

    cursor.execute(f"""
        UPDATE `{target_db}`.`computerpref`
        SET ApptViewNum = COALESCE(
            (SELECT ApptViewNum FROM `{target_db}`.`apptview` WHERE ClinicNum = 1 AND Description = 'All' LIMIT 1),
            2
        )
        WHERE ApptViewNum = 0
    """)
    if cursor.rowcount > 0:
        print(f"  [FIX] Fixed computerpref ApptViewNum=0 for {cursor.rowcount} computers")

    # 2. Dynamic User merge & deduplication
    try:
        from merge_duplicate_users import merge_duplicate_users
        merge_duplicate_users(conn, target_db)
    except Exception as e:
        print(f"  [WARN] User merge: {e}")

    # 3. userclinic & ClinicIsRestricted:
    # Users preserve their natural originating clinics.
    # If a user existed in multiple clinics (e.g. Admin in Boyolali + Jogja), merge_duplicate_users
    # combined their userclinic entries so they have access to those specific clinics.
    # Set ClinicIsRestricted = 1 for all users as requested.
    cursor.execute(f"""
        UPDATE `{target_db}`.`userod`
        SET ClinicIsRestricted = 1
    """)
    print(f"  [FIX] Set ClinicIsRestricted = 1 for all users ({cursor.rowcount} users restricted to their clinics)")

    # Ensure any user without a userclinic row gets their default ClinicNum
    cursor.execute(f"""
        INSERT IGNORE INTO `{target_db}`.`userclinic` (UserNum, ClinicNum)
        SELECT UserNum, ClinicNum FROM `{target_db}`.`userod`
        WHERE ClinicNum > 0 AND UserNum NOT IN (SELECT DISTINCT UserNum FROM `{target_db}`.`userclinic`)
    """)

    # Deduplicate userclinic
    cursor.execute(f"""
        DELETE uc1 FROM `{target_db}`.`userclinic` uc1
        INNER JOIN `{target_db}`.`userclinic` uc2
        WHERE uc1.UserNum = uc2.UserNum AND uc1.ClinicNum = uc2.ClinicNum AND uc1.UserClinicNum > uc2.UserClinicNum
    """)

    # Ensure userod.ClinicNum is valid (matches one of their allowed clinics in userclinic)
    cursor.execute(f"""
        UPDATE `{target_db}`.`userod` u
        SET u.ClinicNum = COALESCE(
            (SELECT MIN(uc.ClinicNum) FROM `{target_db}`.`userclinic` uc WHERE uc.UserNum = u.UserNum),
            1
        )
        WHERE u.ClinicNum = 0 
           OR u.ClinicNum NOT IN (SELECT uc2.ClinicNum FROM `{target_db}`.`userclinic` uc2 WHERE uc2.UserNum = u.UserNum)
    """)

    # 4. userodapptview: ensure each user has views ONLY for their allowed clinics in userclinic
    # Remove any apptviews for clinics the user does not have access to
    cursor.execute(f"""
        DELETE uav FROM `{target_db}`.`userodapptview` uav
        WHERE NOT EXISTS (
            SELECT 1 FROM `{target_db}`.`userclinic` uc
            WHERE uc.UserNum = uav.UserNum AND uc.ClinicNum = uav.ClinicNum
        )
    """)

    # Ensure each user has an apptview for each of their allowed clinics
    cursor.execute(f"""
        INSERT IGNORE INTO `{target_db}`.`userodapptview` (UserNum, ClinicNum, ApptViewNum)
        SELECT uc.UserNum, uc.ClinicNum,
            COALESCE(
                (SELECT ApptViewNum FROM `{target_db}`.`apptview` WHERE ClinicNum = uc.ClinicNum AND Description = 'All' LIMIT 1),
                (SELECT ApptViewNum FROM `{target_db}`.`apptview` WHERE ClinicNum = uc.ClinicNum LIMIT 1),
                2
            )
        FROM `{target_db}`.`userclinic` uc
        WHERE NOT EXISTS (
            SELECT 1 FROM `{target_db}`.`userodapptview` uav
            WHERE uav.UserNum = uc.UserNum AND uav.ClinicNum = uc.ClinicNum
        )
    """)

    # Deduplicate userodapptview
    cursor.execute(f"""
        DELETE uav1 FROM `{target_db}`.`userodapptview` uav1
        INNER JOIN `{target_db}`.`userodapptview` uav2
        WHERE uav1.UserNum = uav2.UserNum AND uav1.ClinicNum = uav2.ClinicNum AND uav1.UserodApptViewNum > uav2.UserodApptViewNum
    """)

    # 5. usergroupattach: deduplicate memberships
    cursor.execute(f"""
        DELETE uga1 FROM `{target_db}`.`usergroupattach` uga1
        INNER JOIN `{target_db}`.`usergroupattach` uga2
        WHERE uga1.UserNum = uga2.UserNum AND uga1.UserGroupNum = uga2.UserGroupNum AND uga1.UserGroupAttachNum > uga2.UserGroupAttachNum
    """)

    # 6. Preferences: Deduplicate preferences (keep lowest PrefNum per PrefName)
    cursor.execute(f"""
        DELETE p1 FROM `{target_db}`.`preference` p1
        INNER JOIN `{target_db}`.`preference` p2 
        WHERE p1.PrefName = p2.PrefName AND p1.PrefNum > p2.PrefNum
    """)
    if cursor.rowcount > 0:
        print(f"  [FIX] Removed {cursor.rowcount} duplicate preferences")

    cursor.execute(f"""
        UPDATE `{target_db}`.`preference` 
        SET ValueString = '0' 
        WHERE PrefName IN ('EasyNoClinics', 'ClinicListIsAlphabetical')
    """)

    conn.commit()
    cursor.close()
    print("  [OK] Post-merge apptview, user clinic permissions, and preferences configured.")


def run_full_verification(conn, target_db):
    cursor = conn.cursor()
    cursor.execute(f"USE `{target_db}`")
    print("\n" + "=" * 70)
    print(f"  MERGE VERIFICATION REPORT: `{target_db}`")
    print("=" * 70)

    # 1. Patients per clinic
    print("\n1. Patient Count by Clinic:")
    cursor.execute(f"""
        SELECT c.ClinicNum, COALESCE(c.Description, 'Unassigned') AS ClinicName, COUNT(p.PatNum) AS TotalPatients
        FROM `{target_db}`.`patient` p
        LEFT JOIN `{target_db}`.`clinic` c ON p.ClinicNum = c.ClinicNum
        GROUP BY p.ClinicNum
        ORDER BY p.ClinicNum
    """)
    for r in cursor.fetchall():
        print(f"   Clinic {r[0]} ({r[1]}): {r[2]:,} patients")

    # 2. PK ranges
    print("\n2. PK Ranges by Clinic in `patient` table:")
    cursor.execute(f"""
        SELECT ClinicNum, MIN(PatNum), MAX(PatNum), COUNT(*)
        FROM `{target_db}`.`patient`
        GROUP BY ClinicNum
        ORDER BY ClinicNum
    """)
    for r in cursor.fetchall():
        print(f"   Clinic {r[0]}: PatNum {r[1]:,} -> {r[2]:,} (Count: {r[3]:,})")

    # 3. Key operational table counts
    print("\n3. Record Counts in Key Tables:")
    for tbl in ["procedurelog", "appointment", "payment", "paysplit", "adjustment", "document", "operatory", "userod"]:
        cursor.execute(f"SELECT COUNT(*) FROM `{target_db}`.`{tbl}`")
        cnt = cursor.fetchone()[0]
        print(f"   {tbl:<18}: {cnt:>10,}")

    # 4. Foreign key integrity checks
    print("\n4. Referential Integrity Checks (Orphan Records):")
    checks = [
        ("procedurelog.PatNum -> patient.PatNum", f"SELECT COUNT(*) FROM `{target_db}`.`procedurelog` WHERE PatNum NOT IN (SELECT PatNum FROM `{target_db}`.`patient`)"),
        ("appointment.PatNum -> patient.PatNum", f"SELECT COUNT(*) FROM `{target_db}`.`appointment` WHERE PatNum > 0 AND PatNum NOT IN (SELECT PatNum FROM `{target_db}`.`patient`)"),
        ("appointment.Op -> operatory.OperatoryNum", f"SELECT COUNT(*) FROM `{target_db}`.`appointment` WHERE Op > 0 AND Op NOT IN (SELECT OperatoryNum FROM `{target_db}`.`operatory`)"),
        ("paysplit.PatNum -> patient.PatNum", f"SELECT COUNT(*) FROM `{target_db}`.`paysplit` WHERE PatNum NOT IN (SELECT PatNum FROM `{target_db}`.`patient`)"),
        ("payment.PatNum -> patient.PatNum", f"SELECT COUNT(*) FROM `{target_db}`.`payment` WHERE PatNum NOT IN (SELECT PatNum FROM `{target_db}`.`patient`)"),
        ("adjustment.PatNum -> patient.PatNum", f"SELECT COUNT(*) FROM `{target_db}`.`adjustment` WHERE PatNum NOT IN (SELECT PatNum FROM `{target_db}`.`patient`)"),
        ("document.PatNum -> patient.PatNum", f"SELECT COUNT(*) FROM `{target_db}`.`document` WHERE PatNum > 0 AND PatNum NOT IN (SELECT PatNum FROM `{target_db}`.`patient`)"),
    ]
    all_clean = True
    for label, query in checks:
        cursor.execute(query)
        orphans = cursor.fetchone()[0]
        status = "✅ 0 orphans (OK)" if orphans == 0 else f"❌ {orphans} ORPHANS FOUND!"
        if orphans > 0:
            all_clean = False
        print(f"   {label:<45}: {status}")

    # 5. AUTO_INCREMENT status
    cursor.execute(f"""
        SELECT COUNT(*) 
        FROM information_schema.TABLES
        WHERE TABLE_SCHEMA = '{target_db}' AND AUTO_INCREMENT >= 10000000
    """)
    total_at_10m = cursor.fetchone()[0]

    print(f"\n5. AUTO_INCREMENT Status ({total_at_10m} tables set to >= 10,000,000):")
    sample_tables = [
        'patient', 'procedurelog', 'appointment', 'payment', 'paysplit', 
        'document', 'operatory', 'securitylog', 'histappointment', 'commlog'
    ]
    cursor.execute(f"""
        SELECT TABLE_NAME, AUTO_INCREMENT 
        FROM information_schema.TABLES
        WHERE TABLE_SCHEMA = '{target_db}' 
          AND TABLE_NAME IN ({", ".join(f"'{t}'" for t in sample_tables)})
        ORDER BY TABLE_NAME
    """)
    for tbl, ai in cursor.fetchall():
        ai_str = f"{ai:,}" if ai else "NULL"
        print(f"   {tbl:<18}: AUTO_INCREMENT = {ai_str}")

    # 6. Uniqueness & Duplicate Checks
    print("\n6. Uniqueness & Duplicate Checks:")
    cursor.execute(f"SELECT COUNT(*) FROM (SELECT PrefName FROM `{target_db}`.`preference` GROUP BY PrefName HAVING COUNT(*) > 1) t")
    dup_prefs = cursor.fetchone()[0]
    cursor.execute(f"SELECT COUNT(*) FROM (SELECT ComputerName FROM `{target_db}`.`computerpref` GROUP BY ComputerName HAVING COUNT(*) > 1) t")
    dup_comps = cursor.fetchone()[0]
    cursor.execute(f"SELECT COUNT(*) FROM (SELECT UserName FROM `{target_db}`.`userod` GROUP BY UserName HAVING COUNT(*) > 1) t")
    dup_users = cursor.fetchone()[0]

    pref_status = "✅ 0 duplicate preferences (OK)" if dup_prefs == 0 else f"❌ {dup_prefs} DUPLICATE PREFERENCES FOUND!"
    comp_status = "✅ 0 duplicate computers (OK)" if dup_comps == 0 else f"❌ {dup_comps} DUPLICATE COMPUTERS FOUND!"
    user_status = "✅ 0 duplicate usernames (OK)" if dup_users == 0 else f"❌ {dup_users} DUPLICATE USERNAMES FOUND!"

    print(f"   Preferences uniqueness       : {pref_status}")
    print(f"   ComputerPref uniqueness      : {comp_status}")
    print(f"   Userod UserName uniqueness   : {user_status}")

    # 7. User Clinic Restrictions Report
    print("\n7. User Clinic Access & Restriction Report:")
    cursor.execute(f"""
        SELECT u.UserName, u.ClinicIsRestricted, 
               GROUP_CONCAT(COALESCE(c.Abbr, uc.ClinicNum) ORDER BY uc.ClinicNum SEPARATOR ', ') AS AllowedClinics
        FROM `{target_db}`.`userod` u
        LEFT JOIN `{target_db}`.`userclinic` uc ON u.UserNum = uc.UserNum
        LEFT JOIN `{target_db}`.`clinic` c ON uc.ClinicNum = c.ClinicNum
        WHERE u.IsHidden = 0
        GROUP BY u.UserNum, u.UserName, u.ClinicIsRestricted
        ORDER BY u.UserName
    """)
    for r in cursor.fetchall():
        restricted_badge = "Restricted" if r[1] == 1 else "Unrestricted"
        print(f"   {r[0]:<32}: {restricted_badge:<12} (Clinics: {r[2]})")

    if dup_prefs > 0 or dup_comps > 0 or dup_users > 0:
        all_clean = False

    cursor.close()
    print("\n" + "=" * 70)
    if all_clean:
        print("  ✅ VERIFICATION SUCCESSFUL: All tables merged cleanly with 0 orphans!")
    else:
        print("  ⚠️  VERIFICATION WARNING: Some integrity issues detected, check logs.")
    print("=" * 70)


def main():
    parser = argparse.ArgumentParser(
        description="Dynamic Multi-Clinic Merge Automation Script for MariaDB / MySQL"
    )
    # Target and Source databases
    parser.add_argument("-t", "--target", default=None, help="Target database name (e.g. helianz)")
    parser.add_argument("-s", "--sources", default=None, help="Comma-separated source databases in clinic order (e.g. helianz_klt,helianz_byl,helianz_jog)")
    parser.add_argument("--clinics", default=None, help="Explicit clinic specifications: '1:db1:Name1:Abbr1, 2:db2:Name2:Abbr2...'")
    parser.add_argument("--klt-db", default=None, help="Source database for Klaten (Clinic 1)")
    parser.add_argument("--byl-db", default=None, help="Source database for Boyolali (Clinic 2)")
    parser.add_argument("--jog-db", default=None, help="Source database for Jogja (Clinic 3)")

    # Connection parameters
    parser.add_argument("-u", "--user", default="root", help="Database username (default: root)")
    parser.add_argument("-p", "--password", default=None, help="Database password (secure prompt if omitted)")
    parser.add_argument("--host", default="localhost", help="Database host (default: localhost)")
    parser.add_argument("--port", type=int, default=3306, help="Database port (default: 3306)")
    parser.add_argument("--bin-dir", default=None, help="Path to MariaDB/MySQL bin directory")

    # Options
    parser.add_argument("--step", type=int, default=DEFAULT_STEP, help=f"Offset round-up step (default: {DEFAULT_STEP:,})")
    parser.add_argument("--autoinc-start", type=int, default=DEFAULT_AUTOINC, help=f"Post-merge auto_increment start value (default: {DEFAULT_AUTOINC:,})")
    parser.add_argument("--skip-backup", action="store_true", help="Skip backup of existing target database")
    parser.add_argument("--no-wipe", dest="wipe_target", action="store_false", default=True, help="Skip wiping target database before merge (default: wipe target first)")
    parser.add_argument("--keep-temp", action="store_true", help="Do not drop working temp databases")
    parser.add_argument("--dry-run", action="store_true", help="Preview calculations and exit without making modifications")
    parser.add_argument("--no-debug", action="store_true", help="Disable verbose debug output (debug enabled by default)")
    parser.add_argument("--conn-timeout", type=int, default=10, help="Database connection timeout in seconds (default: 10)")

    args = parser.parse_args()

    global DEBUG
    DEBUG = not args.no_debug

    debug_log(f"Process PID: {os.getpid()}, Python: {sys.executable} (Version: {sys.version.split()[0]})")
    debug_log(f"Working Directory: {os.getcwd()}")
    debug_log(f"Script Directory: {SCRIPT_DIR}, Repo Root: {REPO_ROOT}")
    debug_log(f"Arguments parsed: target={args.target}, sources={args.sources}, host={args.host}, port={args.port}, user={args.user}, dry_run={args.dry_run}")

    # 1. Resolve Target DB
    target_db = args.target
    if not target_db:
        try:
            target_db = input("Enter target database name [helianz]: ").strip() or "helianz"
        except (EOFError, KeyboardInterrupt):
            target_db = "helianz"
    debug_log(f"Resolved target database: '{target_db}'")

    # 2. Resolve Source Clinics
    clinics = parse_clinic_definitions(
        args.sources, args.clinics, args.klt_db, args.byl_db, args.jog_db
    )
    if not clinics:
        # Prompt interactively if not passed on CLI
        print("\nNo source databases specified via --sources, --clinics, or clinic flags.", flush=True)
        try:
            src_klt = input("Enter Klaten source database [helianz_klt]: ").strip() or "helianz_klt"
            src_byl = input("Enter Boyolali source database [helianz_byl]: ").strip() or "helianz_byl"
            src_jog = input("Enter Jogja source database [helianz_jog]: ").strip() or "helianz_jog"
            clinics = [
                {"ClinicNum": 1, "db": src_klt, "Description": "Klaten 1", "Abbr": "KLT1", "ExternalID": 1},
                {"ClinicNum": 2, "db": src_byl, "Description": "Boyolali 1", "Abbr": "BYL1", "ExternalID": 2},
                {"ClinicNum": 3, "db": src_jog, "Description": "Jogja 1", "Abbr": "JOG1", "ExternalID": 3},
            ]
        except (EOFError, KeyboardInterrupt):
            sys.exit("Aborted by user.")
    debug_log(f"Resolved {len(clinics)} source clinics: {[(c['ClinicNum'], c['db'], c['Description']) for c in clinics]}")

    # 3. Resolve User and Password
    db_user = args.user or "root"
    db_pass = args.password
    if db_pass is None:
        env_pwd = os.environ.get("MYSQL_PWD")
        if env_pwd:
            db_pass = env_pwd
            debug_log("Database password loaded from MYSQL_PWD environment variable.")
        else:
            try:
                db_pass = getpass.getpass(f"Enter MariaDB password for user '{db_user}': ")
            except (EOFError, KeyboardInterrupt):
                sys.exit("\nAborted by user.")
    debug_log(f"Database user: '{db_user}', password length: {len(db_pass) if db_pass else 0}")

    # 4. Resolve MariaDB bin directory
    bin_dir = find_mariadb_bin(args.bin_dir)
    if not bin_dir:
        try:
            bin_dir = input("Enter path to MariaDB/MySQL bin directory: ").strip()
        except (EOFError, KeyboardInterrupt):
            sys.exit("Aborted by user.")
        if not bin_dir or not os.path.exists(os.path.join(bin_dir, "mysql.exe")):
            sys.exit(f"Error: mysql.exe not found in '{bin_dir}'.")

    mysql_exe = os.path.join(bin_dir, "mysql.exe")
    mysqldump_exe = os.path.join(bin_dir, "mysqldump.exe")
    python_exe = get_python_exe()
    debug_log(f"Binaries: mysql='{mysql_exe}' (exists: {os.path.exists(mysql_exe)}), mysqldump='{mysqldump_exe}' (exists: {os.path.exists(mysqldump_exe)}), python='{python_exe}'")

    # Environment variables to pass credentials cleanly to child processes
    child_env = {
        "MYSQL_HOST": args.host,
        "MYSQL_TCP_PORT": str(args.port),
        "MYSQL_USER": db_user,
        "MYSQL_PWD": db_pass,
    }

    log_header("DYNAMIC MULTI-CLINIC MERGE")
    print(f"  Target Database : {target_db}")
    print(f"  Wipe Target DB  : {'YES (Will drop and recreate clean empty database)' if args.wipe_target else 'NO (Preserve target DB)'}")
    print(f"  Database User   : {db_user}")
    print(f"  Database Host   : {args.host}:{args.port}")
    print(f"  Bin Directory   : {bin_dir}")
    print(f"  Offset Step     : +{args.step:,} (round up)")
    print(f"  Next AutoInc    : {args.autoinc_start:,}")
    print(f"  Clinics to Merge: {len(clinics)}")
    for c in clinics:
        print(f"    - Clinic {c['ClinicNum']}: `{c['db']}` ({c['Description']}, {c['Abbr']})")
    if args.dry_run:
        print("  ⚠️  MODE: DRY RUN ONLY — No modifications will be made.")

    # 5. Connect and verify databases
    log_step(1, "Pre-flight Verification")
    debug_log(f"Initiating pre-flight verification: Host={args.host}:{args.port}, User='{db_user}', Timeout={args.conn_timeout}s")

    # Probe MariaDB via native CLI binary first
    if os.path.exists(mysql_exe):
        debug_log(f"Probing MariaDB via native CLI binary: {mysql_exe}...")
        cli_probe = run_shell_cmd(f'"{mysql_exe}" -h {args.host} -P {args.port} -u {db_user} -e "SELECT @@version;"', env_vars=child_env, check=False)
        if cli_probe.returncode == 0:
            ver_text = cli_probe.stdout.strip().replace("\r", "").replace("\n", " ")
            debug_log(f"[OK] Native CLI mysql.exe connected successfully! Version output: {ver_text}")
        else:
            err_text = cli_probe.stderr.strip() or cli_probe.stdout.strip()
            debug_log(f"[!] Native CLI mysql.exe probe returned code {cli_probe.returncode}: {err_text}")

    print(f"  Connecting to database at {args.host}:{args.port} as '{db_user}'...", flush=True)
    try:
        conn = get_mysql_conn(args.host, args.port, db_user, db_pass, timeout=args.conn_timeout)
        print(f"  [OK] Connected to MariaDB/MySQL server successfully.", flush=True)
        cursor = conn.cursor()
        print("  Retrieving database list...", flush=True)
        debug_log("Executing: SHOW DATABASES")
        cursor.execute("SHOW DATABASES")
        raw_dbs = cursor.fetchall()
        existing_dbs = {row[0].lower() for row in raw_dbs}
        cursor.close()
        debug_log(f"Databases found ({len(existing_dbs)}): {sorted(existing_dbs)}")
    except Exception as e:
        debug_log(f"[EXCEPTION] Connection/Query error: {type(e).__name__}: {e}")
        print(f"\n[!] Failed to connect to database at {args.host}:{args.port}", flush=True)
        print(f"    Error: {e}", flush=True)
        print(f"\n    Troubleshooting:", flush=True)
        print(f"    - If MariaDB is on a remote server/IP, specify --host <server_ip> (e.g. --host 192.168.1.50)", flush=True)
        print(f"    - If MariaDB is local on this machine, verify service status in PowerShell: Get-Service *mariadb*, *mysql*", flush=True)
        print(f"    - Verify the MariaDB port is {args.port}", flush=True)
        print(f"    - Verify password for user '{db_user}'", flush=True)
        sys.exit(1)

    print(f"  Checking {len(clinics)} source databases on server...", flush=True)
    for c in clinics:
        src = c["db"]
        debug_log(f"Verifying existence of source DB '{src}' for Clinic {c['ClinicNum']}...")
        if src.lower() not in existing_dbs:
            debug_log(f"Source DB '{src}' NOT found in existing databases: {sorted(existing_dbs)}")
            print(f"\n[!] Error: Source database `{src}` does not exist on {args.host}:{args.port}!", flush=True)
            print(f"    Databases found on server: {', '.join(sorted(existing_dbs))}", flush=True)
            print(f"    Please verify database names or restore source dumps first.", flush=True)
            sys.exit(1)
        debug_log(f"Source DB '{src}' confirmed on server.")
        print(f"  [OK] Found source database `{src}` for Clinic {c['ClinicNum']} ({c['Description']})", flush=True)

    # Preview PKs and calculate projected offsets
    print("\n  Analyzing Source Max PKs & Projected Offsets...", flush=True)
    base_clinic = clinics[0]
    debug_log(f"Analyzing max PK for base clinic `{base_clinic['db']}`...")
    base_max, base_top = get_max_pk_in_db(conn, base_clinic["db"])
    print(f"    Clinic {base_clinic['ClinicNum']} (`{base_clinic['db']}`) : Max PK = {base_max:,} (Base, offset +0)", flush=True)

    running_target_max = base_max
    for c in clinics[1:]:
        debug_log(f"Analyzing max PK for clinic {c['ClinicNum']} `{c['db']}`...")
        c_max, _ = get_max_pk_in_db(conn, c["db"])
        offset_val = compute_rounded_offset(running_target_max, args.step)
        est_after = offset_val + c_max
        debug_log(f"Clinic {c['ClinicNum']} `{c['db']}`: max_pk={c_max:,}, offset={offset_val:,}, est_max={est_after:,}")
        print(f"    Clinic {c['ClinicNum']} (`{c['db']}`) : Max PK = {c_max:,} -> Offset +{offset_val:,} (Range: {offset_val+1:,} -> {est_after:,})", flush=True)
        running_target_max = est_after

    if args.dry_run:
        print("\n[DRY RUN COMPLETE] Configuration and calculated offsets validated successfully.")
        conn.close()
        return

    # Track sequential step numbering dynamically
    step_num = 2

    # 6. Backup existing target if present
    target_exists = target_db.lower() in existing_dbs
    if target_exists and not args.skip_backup:
        log_step(step_num, f"Backing Up Existing `{target_db}` Database")
        step_num += 1
        os.makedirs(BACKUP_DIR, exist_ok=True)
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        backup_file = os.path.join(BACKUP_DIR, f"{target_db}_pre_merge_{timestamp}.sql")
        print(f"  Dumping `{target_db}` -> {backup_file} ...")
        cmd_backup = f'"{mysqldump_exe}" -h {args.host} -P {args.port} -u {db_user} --single-transaction --routines --triggers --events {target_db} > "{backup_file}"'
        run_shell_cmd(cmd_backup, env_vars=child_env)
        print(f"  [OK] Backup completed ({os.path.getsize(backup_file):,} bytes)")

    # 7. Wipe Target DB first (if enabled)
    if args.wipe_target:
        log_step(step_num, f"Wiping Target Database `{target_db}` Clean")
        step_num += 1
        print(f"  Dropping existing database `{target_db}` if present...")
        drop_sql = f"DROP DATABASE IF EXISTS `{target_db}`;"
        run_shell_cmd(f'"{mysql_exe}" -h {args.host} -P {args.port} -u {db_user} -e "{drop_sql}"', env_vars=child_env)

        print(f"  Creating fresh empty database `{target_db}` (utf8mb4)...")
        create_sql = f"CREATE DATABASE `{target_db}` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;"
        run_shell_cmd(f'"{mysql_exe}" -h {args.host} -P {args.port} -u {db_user} -e "{create_sql}"', env_vars=child_env)

        # Verify target is completely empty
        cursor = conn.cursor()
        cursor.execute("SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = %s", (target_db,))
        tbl_count = cursor.fetchone()[0]
        cursor.close()
        print(f"  [OK] Target database `{target_db}` wiped clean ({tbl_count} tables). Ready for fresh merge.")
    else:
        log_step(step_num, f"Target Database Preparation `{target_db}`")
        step_num += 1
        print("  [SKIP] Skipping wipe of target database (--no-wipe flag specified).")

    # 8. Seed Target from Clinic 1
    log_step(step_num, f"Seeding Target Database `{target_db}` from Clinic 1 (`{base_clinic['db']}`)")
    step_num += 1
    print(f"  Cloning `{base_clinic['db']}` schema & data into `{target_db}`...")
    clone_cmd = f'"{mysqldump_exe}" -h {args.host} -P {args.port} -u {db_user} --single-transaction --routines --triggers --events {base_clinic["db"]} | "{mysql_exe}" -h {args.host} -P {args.port} -u {db_user} {target_db}'
    run_shell_cmd(clone_cmd, env_vars=child_env)
    print(f"  [OK] Seeded target with Clinic 1 ({base_clinic['Description']}) data.")

    ensure_clinics_registered(conn, target_db, clinics)

    print(f"  Segregating Clinic 1 records in `{target_db}` (ClinicNum 0 -> {base_clinic['ClinicNum']})...")
    try:
        from segregate_clinic import segregate_clinic_data
        segregate_clinic_data(base_clinic["ClinicNum"], db=target_db, conn=conn)
        print("  [OK] Clinic 1 segregation completed.")
    except Exception as ex:
        debug_log(f"In-process segregation fallback ({ex})...")
        run_shell_cmd(f'"{python_exe}" "{SEGREGATE_SCRIPT}" {base_clinic["ClinicNum"]} --db {target_db} --yes', env_vars=child_env, print_stdout=True)
        print("  [OK] Clinic 1 segregation completed.")

    # 9. Process Subsequent Clinics Sequentially
    for c in clinics[1:]:
        c_num = c["ClinicNum"]
        c_db = c["db"]
        c_desc = c["Description"]

        current_target_max, _ = get_max_pk_in_db(conn, target_db)
        actual_offset = compute_rounded_offset(current_target_max, args.step)

        tmp_db = f"_tmp_merge_c{c_num}_{int(time.time())}"
        log_step(step_num, f"Processing Clinic {c_num} ({c_desc}) via Temporary DB `{tmp_db}` (Offset: +{actual_offset:,})")
        step_num += 1

        try:
            print(f"  Creating temporary database `{tmp_db}`...")
            run_shell_cmd(f'"{mysql_exe}" -h {args.host} -P {args.port} -u {db_user} -e "CREATE DATABASE `{tmp_db}` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;"', env_vars=child_env)

            print(f"  Cloning `{c_db}` into `{tmp_db}`...")
            run_shell_cmd(f'"{mysqldump_exe}" -h {args.host} -P {args.port} -u {db_user} --single-transaction --routines --triggers --events {c_db} | "{mysql_exe}" -h {args.host} -P {args.port} -u {db_user} {tmp_db}', env_vars=child_env)

            ensure_clinics_registered(conn, tmp_db, clinics)

            print(f"  Segregating Clinic {c_num} records in `{tmp_db}` (ClinicNum 0 -> {c_num})...")
            try:
                from segregate_clinic import segregate_clinic_data
                segregate_clinic_data(c_num, db=tmp_db, conn=conn)
            except Exception as ex:
                debug_log(f"In-process segregation fallback ({ex})...")
                run_shell_cmd(f'"{python_exe}" "{SEGREGATE_SCRIPT}" {c_num} --db {tmp_db} --yes', env_vars=child_env, print_stdout=True)

            print(f"  Applying PK/FK offset +{actual_offset:,} to `{tmp_db}`...")
            try:
                from offset_db import run_offset
                run_offset(actual_offset, db=tmp_db, conn=conn)
            except Exception as ex:
                debug_log(f"In-process offset fallback ({ex})...")
                run_shell_cmd(f'"{python_exe}" "{OFFSET_SCRIPT}" {actual_offset} --db {tmp_db}', env_vars=child_env, print_stdout=True)

            print(f"  Merging `{tmp_db}` into `{target_db}`...")
            try:
                from merge_clinics import run_merge
                run_merge(target=target_db, sources=[tmp_db], conn=conn)
            except Exception as ex:
                debug_log(f"In-process merge fallback ({ex})...")
                run_shell_cmd(f'"{python_exe}" "{MERGE_SCRIPT}" --target {target_db} --sources {tmp_db}', env_vars=child_env, print_stdout=True)

        finally:
            if not args.keep_temp:
                print(f"  Cleaning up temporary DB `{tmp_db}`...")
                run_shell_cmd(f'"{mysql_exe}" -h {args.host} -P {args.port} -u {db_user} -e "DROP DATABASE IF EXISTS `{tmp_db}`;"', env_vars=child_env)
            else:
                print(f"  [NOTE] Kept temporary DB `{tmp_db}`")

    # Post-Merge AUTO_INCREMENT
    log_step(step_num, f"Resetting AUTO_INCREMENT to {args.autoinc_start:,}")
    step_num += 1
    try:
        from set_autoinc import set_auto_increment
        set_auto_increment(db=target_db, start_val=args.autoinc_start, conn=conn)
    except Exception as ex:
        debug_log(f"In-process autoinc fallback ({ex})...")
        run_shell_cmd(f'"{python_exe}" "{AUTOINC_SCRIPT}" --db {target_db} --start {args.autoinc_start}', env_vars=child_env, print_stdout=True)

    # Post-Merge Fixes
    log_step(step_num, "Applying Post-Merge ApptView, User, and Preference Fixes")
    step_num += 1
    apply_post_merge_fixes(conn, target_db, clinics)

    # Final Verification Report
    log_step(step_num, "Running Final Integrity & Data Verification")
    run_full_verification(conn, target_db)

    conn.close()
    log_header("MERGE COMPLETED SUCCESSFULLY!")


if __name__ == "__main__":
    main()

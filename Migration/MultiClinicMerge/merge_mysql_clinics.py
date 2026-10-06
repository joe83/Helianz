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
import re
import sys
import math
import time
import shutil
import getpass
import argparse
import subprocess
from datetime import datetime
from collections import defaultdict

if sys.platform == "win32":
    try:
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
        sys.stderr.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass

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


def run_shell_cmd(cmd, env_vars=None, check=True, print_stdout=False, timeout=None):
    """
    Execute a shell command with real-time debug logging and optional streaming output.
    Supports a timeout parameter to prevent indefinite hangs.
    """
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
        try:
            for line in iter(proc.stdout.readline, ""):
                print(line, end="", flush=True)
                lines.append(line)
            proc.stdout.close()
            proc.wait(timeout=timeout)
        except subprocess.TimeoutExpired:
            proc.kill()
            raise TimeoutError(f"Command timed out after {timeout}s: {cmd}")
        elapsed = time.time() - t0
        debug_log(f"run_shell_cmd: Completed in {elapsed:.2f}s (Exit code: {proc.returncode})")
        if proc.returncode != 0 and check:
            crash_note = NTSTATUS_NAMES.get(proc.returncode, "")
            last_lines = "".join(lines[-10:]).strip()
            err_msg = crash_note if not last_lines else f"{last_lines}\n{crash_note}".strip()
            raise RuntimeError(f"Command failed (exit {proc.returncode}): {cmd}\nError: {err_msg}")
        return SimpleProcResult(proc.returncode, "".join(lines))
    else:
        try:
            proc = subprocess.run(
                cmd, shell=True, capture_output=True, text=True, env=env, encoding="utf-8", errors="replace", timeout=timeout
            )
        except subprocess.TimeoutExpired:
            raise TimeoutError(f"Command timed out after {timeout}s: {cmd}")
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
            abbr_guess = "".join(w[:3].upper() for w in name_guess.split())
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


def ensure_clinic_admin_users(conn, target_db, clinics):
    """
    Generate dedicated admin users for each clinic:
      - admin klaten (Clinic 1)
      - admin boyolali (Clinic 2)
      - admin jogja (Clinic 3)
    Each has all permissions in their clinic, but ClinicIsRestricted=1 and userclinic restricted ONLY to their clinic.
    Also ensures the Email column and index exist on userod (commit 8295205).
    """
    cursor = conn.cursor(dictionary=True)

    # 1. Ensure Email column and index on userod (commit 8295205)
    cursor.execute(f"""
        SELECT COUNT(*) as c FROM information_schema.COLUMNS 
        WHERE TABLE_SCHEMA = '{target_db}' AND TABLE_NAME = 'userod' AND COLUMN_NAME = 'Email'
    """)
    if cursor.fetchone()['c'] == 0:
        cursor.execute(f"ALTER TABLE `{target_db}`.userod ADD COLUMN Email VARCHAR(255) NOT NULL DEFAULT '' AFTER UserName")
        cursor.execute(f"ALTER TABLE `{target_db}`.userod ADD INDEX idx_userod_email (Email)")
        print("  [FIX] Added Email column and index to userod (commit 8295205)")
    else:
        cursor.execute(f"""
            SELECT COUNT(*) as c FROM information_schema.STATISTICS 
            WHERE TABLE_SCHEMA = '{target_db}' AND TABLE_NAME = 'userod' AND INDEX_NAME = 'idx_userod_email'
        """)
        if cursor.fetchone()['c'] == 0:
            cursor.execute(f"ALTER TABLE `{target_db}`.userod ADD INDEX idx_userod_email (Email)")

    # 2. Get default password hash from existing Admin or Owner
    cursor.execute(f"SELECT Password, PasswordIsStrong FROM `{target_db}`.userod WHERE LOWER(UserName) = 'admin' LIMIT 1")
    admin_row = cursor.fetchone()
    if not admin_row or not admin_row.get('Password'):
        cursor.execute(f"SELECT Password, PasswordIsStrong FROM `{target_db}`.userod WHERE Password != '' LIMIT 1")
        admin_row = cursor.fetchone()

    pwd = admin_row['Password'] if admin_row else ''
    pwd_strong = admin_row['PasswordIsStrong'] if admin_row else 1

    # Remove redundant 'admin boy' if present (keeping 'admin boyolali')
    cursor.execute(f"SELECT UserNum FROM `{target_db}`.userod WHERE LOWER(UserName) = 'admin boy'")
    admin_boy = cursor.fetchone()
    if admin_boy:
        boy_uid = admin_boy['UserNum']
        cursor.execute(f"DELETE FROM `{target_db}`.userclinic WHERE UserNum = %s", (boy_uid,))
        cursor.execute(f"DELETE FROM `{target_db}`.usergroupattach WHERE UserNum = %s", (boy_uid,))
        cursor.execute(f"DELETE FROM `{target_db}`.userodapptview WHERE UserNum = %s", (boy_uid,))
        cursor.execute(f"DELETE FROM `{target_db}`.userodpref WHERE UserNum = %s", (boy_uid,))
        cursor.execute(f"DELETE FROM `{target_db}`.alertsub WHERE UserNum = %s", (boy_uid,))
        cursor.execute(f"DELETE FROM `{target_db}`.userod WHERE UserNum = %s", (boy_uid,))
        print("  [FIX] Removed redundant 'admin boy' user (using 'admin boyolali')")

    # 3. Clinic Admin definitions: (UserName, ClinicNum, Email)
    admin_defs = [
        ("admin klaten", 1, "admin.klaten@dsmile.id"),
        ("admin boyolali", 2, "admin.boyolali@dsmile.id"),
        ("admin jogja", 3, "admin.jogja@dsmile.id"),
    ]

    for uname, clinic_num, email in admin_defs:
        cursor.execute(f"SELECT UserNum FROM `{target_db}`.userod WHERE LOWER(UserName) = %s", (uname.lower(),))
        existing = cursor.fetchone()

        if existing:
            user_num = existing['UserNum']
            cursor.execute(f"""
                UPDATE `{target_db}`.userod
                SET ClinicNum = %s, ClinicIsRestricted = 1, UserGroupNum = 1, Email = %s, PasswordIsStrong = %s
                WHERE UserNum = %s
            """, (clinic_num, email, pwd_strong, user_num))
        else:
            cursor.execute(f"""
                INSERT INTO `{target_db}`.userod (
                    UserName, Email, Password, UserGroupNum, EmployeeNum, ClinicNum, ProvNum,
                    IsHidden, TaskListInBox, AnesthProvType, DefaultHidePopups, PasswordIsStrong,
                    ClinicIsRestricted, InboxHidePopups, UserNumCEMT, DateTFail, FailedAttempts,
                    DomainUser, IsPasswordResetRequired, MobileWebPin, MobileWebPinFailedAttempts,
                    DateTLastLogin, EClipboardClinicalPin, BadgeId
                ) VALUES (
                    %s, %s, %s, 1, 0, %s, 0,
                    0, 0, 3, 0, %s,
                    1, 0, 0, '0001-01-01 00:00:00', 0,
                    '', 0, '', 0,
                    '0001-01-01 00:00:00', '', '0'
                )
            """, (uname, email, pwd, clinic_num, pwd_strong))
            user_num = cursor.lastrowid
            print(f"  [USER] Generated clinic admin: '{uname}' (UserNum={user_num}, Clinic={clinic_num}, Email={email})")

        # Ensure user belongs to Admin Group (UserGroupNum = 1) in usergroupattach
        cursor.execute(f"SELECT 1 FROM `{target_db}`.usergroupattach WHERE UserNum = %s AND UserGroupNum = 1", (user_num,))
        if not cursor.fetchone():
            cursor.execute(f"INSERT INTO `{target_db}`.usergroupattach (UserNum, UserGroupNum) VALUES (%s, 1)", (user_num,))

        # Ensure userclinic ONLY has their specific clinic (strict clinic restriction)
        cursor.execute(f"DELETE FROM `{target_db}`.userclinic WHERE UserNum = %s", (user_num,))
        cursor.execute(f"INSERT INTO `{target_db}`.userclinic (UserNum, ClinicNum) VALUES (%s, %s)", (user_num, clinic_num))

        # Ensure apptview ONLY for their clinic
        cursor.execute(f"DELETE FROM `{target_db}`.userodapptview WHERE UserNum = %s", (user_num,))
        cursor.execute(f"""
            INSERT INTO `{target_db}`.userodapptview (UserNum, ClinicNum, ApptViewNum)
            SELECT %s, %s, COALESCE(
                (SELECT ApptViewNum FROM `{target_db}`.apptview WHERE ClinicNum = %s AND Description = 'All' LIMIT 1),
                (SELECT ApptViewNum FROM `{target_db}`.apptview WHERE ClinicNum = %s LIMIT 1),
                2
            )
        """, (user_num, clinic_num, clinic_num, clinic_num))

    # Also ensure the general 'Admin' and 'Owner' are unrestricted global admins with access to all clinics
    cursor.execute(f"""
        UPDATE `{target_db}`.userod 
        SET ClinicIsRestricted = 0, ClinicNum = 1, UserGroupNum = 1, Email = 'admin@dsmile.id' 
        WHERE LOWER(UserName) = 'admin'
    """)
    cursor.execute(f"""
        UPDATE `{target_db}`.userod 
        SET ClinicIsRestricted = 0, ClinicNum = 1, UserGroupNum = 1 
        WHERE LOWER(UserName) = 'owner'
    """)
    cursor.execute(f"""
        UPDATE `{target_db}`.userod 
        SET ClinicIsRestricted = 0, ClinicNum = 1, UserGroupNum = 1 
        WHERE LOWER(UserName) = 'endru'
    """)
    cursor.execute(f"SELECT UserNum, UserName FROM `{target_db}`.userod WHERE LOWER(UserName) IN ('admin', 'owner', 'endru')")
    global_admins = cursor.fetchall()
    for gadmin in global_admins:
        guid = gadmin['UserNum']
        for c in clinics:
            cnum = c.get('ClinicNum') or c.get('clinic_num')
            cursor.execute(f"SELECT 1 FROM `{target_db}`.userclinic WHERE UserNum = %s AND ClinicNum = %s", (guid, cnum))
            if not cursor.fetchone():
                cursor.execute(f"INSERT INTO `{target_db}`.userclinic (UserNum, ClinicNum) VALUES (%s, %s)", (guid, cnum))
        cursor.execute(f"SELECT 1 FROM `{target_db}`.usergroupattach WHERE UserNum = %s AND UserGroupNum = 1", (guid,))
        if not cursor.fetchone():
            cursor.execute(f"INSERT INTO `{target_db}`.usergroupattach (UserNum, UserGroupNum) VALUES (%s, 1)", (guid,))

    # Deduplicate grouppermission
    cursor.execute(f"""
        DELETE gp1 FROM `{target_db}`.grouppermission gp1
        INNER JOIN `{target_db}`.grouppermission gp2 
        WHERE gp1.UserGroupNum = gp2.UserGroupNum 
          AND gp1.PermType = gp2.PermType 
          AND gp1.FKey = gp2.FKey 
          AND gp1.GroupPermNum > gp2.GroupPermNum
    """)

    conn.commit()
    cursor.close()
    print("  [OK] Dedicated clinic admin users and global admins configured with full permissions.")


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

    # Ensure Patient Select auto-populates on open across all computers
    cursor.execute(f"UPDATE `{target_db}`.`computerpref` SET PatSelectSearchMode = 2")
    cursor.execute(f"UPDATE `{target_db}`.`preference` SET ValueString = '1' WHERE PrefName = 'PatientSelectSearchWithEmptyParams'")
    cursor.execute(f"UPDATE `{target_db}`.`preference` SET ValueString = '0' WHERE PrefName = 'PatientSelectUsesSearchButton'")
    cursor.execute(f"UPDATE `{target_db}`.`preference` SET ValueString = '1' WHERE PrefName = 'EnterpriseAllowRefreshWhileTyping'")
    print(f"  [FIX] Configured patient search preferences (auto-refresh & instant first 40 load)")

    # 2. Dynamic User merge & deduplication
    try:
        from merge_duplicate_users import merge_duplicate_users
        merge_duplicate_users(conn, target_db)
    except Exception as e:
        print(f"  [WARN] User merge: {e}")

    # 2b. Generate clinic admin users & ensure Email column
    ensure_clinic_admin_users(conn, target_db, clinics)

    # 3. userclinic & ClinicIsRestricted:
    # Users preserve their natural originating clinics.
    # If a user existed in multiple clinics (e.g. Admin in Boyolali + Jogja), merge_duplicate_users
    # combined their userclinic entries so they have access to those specific clinics.
    # Set ClinicIsRestricted = 1 for all regular clinic users, and 0 for global admins (Admin, Owner, endru)
    cursor.execute(f"""
        UPDATE `{target_db}`.`userod`
        SET ClinicIsRestricted = 1
        WHERE LOWER(UserName) NOT IN ('admin', 'owner', 'endru')
    """)
    cursor.execute(f"""
        UPDATE `{target_db}`.`userod`
        SET ClinicIsRestricted = 0, ClinicNum = 1, UserGroupNum = 1
        WHERE LOWER(UserName) IN ('admin', 'owner', 'endru')
    """)
    print(f"  [FIX] Set ClinicIsRestricted = 1 for clinic users, ClinicIsRestricted = 0 for super-admin / owner / endru")

    # Ensure any user without a userclinic row gets their default ClinicNum
    cursor.execute(f"""
        INSERT IGNORE INTO `{target_db}`.`userclinic` (UserNum, ClinicNum)
        SELECT UserNum, ClinicNum FROM `{target_db}`.`userod`
        WHERE ClinicNum > 0 AND UserNum NOT IN (SELECT DISTINCT UserNum FROM `{target_db}`.`userclinic`)
    """)

    # Ensure global admins (Admin, Owner, endru) have access to ALL clinics
    cursor.execute(f"SELECT UserNum FROM `{target_db}`.`userod` WHERE LOWER(UserName) IN ('admin', 'owner', 'endru')")
    g_admin_rows = cursor.fetchall()
    for g_row in g_admin_rows:
        g_uid = g_row['UserNum'] if isinstance(g_row, dict) else g_row[0]
        for c in clinics:
            cnum = c.get('ClinicNum') or c.get('clinic_num')
            cursor.execute(f"""
                INSERT IGNORE INTO `{target_db}`.`userclinic` (UserNum, ClinicNum)
                VALUES (%s, %s)
            """, (g_uid, cnum))

    # Deduplicate userclinic
    cursor.execute(f"""
        DELETE uc1 FROM `{target_db}`.`userclinic` uc1
        INNER JOIN `{target_db}`.`userclinic` uc2
        WHERE uc1.UserNum = uc2.UserNum AND uc1.ClinicNum = uc2.ClinicNum AND uc1.UserClinicNum > uc2.UserClinicNum
    """)

    # Deduplicate grouppermission
    cursor.execute(f"""
        DELETE gp1 FROM `{target_db}`.`grouppermission` gp1
        INNER JOIN `{target_db}`.`grouppermission` gp2 
        WHERE gp1.UserGroupNum = gp2.UserGroupNum 
          AND gp1.PermType = gp2.PermType 
          AND gp1.FKey = gp2.FKey 
          AND gp1.GroupPermNum > gp2.GroupPermNum
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
        WHERE PrefName IN ('EasyNoClinics', 'ClinicListIsAlphabetical', 'ProcCodeListShowHidden')
    """)

    # 7. Synchronize patient.ImageFolder to match PatNum for hybrid media resolution
    cursor.execute(f"""
        UPDATE `{target_db}`.`patient`
        SET ImageFolder = CAST(PatNum AS CHAR)
        WHERE ImageFolder IS NOT NULL AND ImageFolder != ''
    """)
    if cursor.rowcount > 0:
        print(f"  [FIX] Synchronized {cursor.rowcount} patient ImageFolder records to match offset PatNum")

    # 8. Harmonize & Deduplicate Procedure Codes (remapping duplicate CodeNums across proclog/fees & quarantining obsolete codes)
    harmonize_and_deduplicate_procedures(conn, target_db, clinics)

    # 9. Generate Per-Clinic Procedure & Category Catalogs (clinic_def & clinic_procedurecode)
    generate_clinic_procedure_catalogs(conn, target_db, clinics)

    # 10. Consolidate Unified Fee Schedules (FeeSched 53, 56, 57, 58)
    consolidate_unified_fees(conn, target_db)

    # 11. Seed ClinicNum = 0 Baseline Fees for all clinic fee schedules
    seed_baseline_fees(conn, target_db)

    conn.commit()
    cursor.close()
    print("  [OK] Post-merge apptview, user clinic permissions, preferences, and clinic catalogs configured.")


CANONICAL_PROC_CATS = [
    (73, 0, 'EXAM', 0),
    (74, 1, 'CLEAN', 0),
    (75, 2, 'CONS', 0),
    (76, 3, 'ENDO', 0),
    (77, 4, 'PERIO', 0),
    (78, 5, 'PROST', 0),
    (79, 6, 'COSME', 0),
    (80, 7, 'IMPLANT', 0),
    (82, 8, 'OS', 0),
    (83, 9, 'ORTHO', 0),
    (259, 10, 'PEDO', 0),
    (981, 11, 'OBAT', 1),
    (114, 12, 'HIDDEN', 1),
    (273, 13, 'HARGA LAMA', 1),
]


def get_norm_proc_key(pcode, desc):
    clean = re.sub(r'[\s_]+', '', pcode or '').upper()
    if clean == 'OS' and 'hect' in (desc or '').lower():
        return 'OS_HECT'
    if clean == 'PROM2' and 'behel' in (desc or '').lower():
        return 'PROM2_BEHEL'
    if clean == 'EX1' and 'extract' in (desc or '').lower():
        return 'EX1_EXTRACT'
    return clean


def to_canonical_proc_code(pcode, desc):
    clean = (pcode or '').strip()
    if clean.upper() == 'OS' and 'hect' in (desc or '').lower():
        return 'OS (Hecting)'
    if re.sub(r'[\s_]+', '', clean).upper() == 'PROM2' and 'behel' in (desc or '').lower():
        return 'PROM2 (Behel)'
    m = re.match(r'^([A-Za-z]+)\s*(\d+)$', clean)
    if m:
        return f"{m.group(1).upper()}{m.group(2)}"
    return re.sub(r'\s+', ' ', clean).upper()


CAT_CLEAN_MAP = {
    'EXAMS & XRAYS': 73, 'EXAM': 73, 'EXAMS': 73,
    'CLEANINGS': 74, 'CLEAN': 74, 'CLEANING': 74,
    'CONSERVATION': 75, 'CONS': 75, 'FILLINGS': 75, 'KONSERVASI': 75,
    'ENDO': 76, 'ENDODONTIC': 76,
    'PERIO': 77, 'PERIODONTIC': 77, 'KURETASE': 77,
    'DENTURES': 78, 'PROST': 78, 'PROSTHO': 78, 'CROWN & BRIDGE': 78,
    'COSMETIC': 79, 'COSME': 79,
    'IMPLANTS': 80, 'IMPLANT': 80,
    'ORAL SURGERY': 82, 'OS': 82, 'BEDAH MULUT': 82,
    'ORTHO': 83, 'ORTHODONTIC': 83,
    'PEDO': 259, 'PEDODONTIC': 259
}


def map_category_to_canonical(name):
    if not name:
        return 114
    n = name.strip().lower()
    if 'exam' in n or 'xray' in n:
        return 73
    if 'clean' in n:
        return 74
    if 'cons' in n or 'fill' in n or 'konservasi' in n:
        return 75
    if 'endo' in n:
        return 76
    if 'perio' in n or 'kuretase' in n:
        return 77
    if 'prost' in n or 'denture' in n or 'crown' in n or 'bridge' in n:
        return 78
    if 'cosme' in n:
        return 79
    if 'implant' in n:
        return 80
    if n in ('os', 'oral surgery', 'bedah mulut') or 'bedah' in n:
        return 82
    if 'ortho' in n:
        return 83
    if 'pedo' in n:
        return 259
    if 'obat' in n:
        return 981
    return 114


def harmonize_and_deduplicate_procedures(conn, target_db, clinics):
    """
    Harmonizes procedure codes across clinics:
      1. Identifies active procedure codes from source clinics (non-hidden, non-obat).
      2. Normalizes codes (e.g. 'KN 1' -> 'KN1', 'EX 2' -> 'EX2', 'OR 1' -> 'OR1').
      3. Preserves clinical distinctions ('OS' vs 'OS (Hecting)', 'PROM2' vs 'PROM2 (Behel)').
      4. Quarantines obsolete/hidden codes into DefNum 273 (HARGA LAMA, IsHidden = 1).
      5. Deduplicates active procedures:
         - Maps duplicate CodeNums to canonical CodeNum (preferring base clinic / lowest ID).
         - Remaps foreign keys in procedurelog, fee, procbuttonitem, proccodenote, recalltrigger, etc.
         - Merges and deduplicates clinic-specific fee records under canonical CodeNum.
         - Safely removes redundant procedurecode duplicate rows.
    """
    print("  [PROCEDURECODE] Harmonizing and deduplicating procedure catalog...")
    cursor = conn.cursor(dictionary=True, buffered=True)

    # 1. Collect active keys from source clinics
    active_keys = set()
    clinic_active_info = {}
    for c in clinics:
        c_db = c.get("db")
        if not c_db:
            continue
        try:
            c_cur = conn.cursor(dictionary=True, buffered=True)
            c_cur.execute(f"""
                SELECT p.ProcCode, p.Descript, d.ItemName
                FROM `{c_db}`.procedurecode p
                JOIN `{c_db}`.definition d ON p.ProcCat = d.DefNum
                WHERE d.Category = 11 AND d.IsHidden = 0 AND LOWER(d.ItemName) NOT LIKE '%obat%'
            """)
            for r in c_cur.fetchall():
                norm_k = re.sub(r'[\s_]+', '', r['ProcCode'] or '').upper()
                active_keys.add(norm_k)
                if norm_k not in clinic_active_info:
                    clinic_active_info[norm_k] = r
            c_cur.close()
        except Exception as e:
            debug_log(f"Notice getting active procs from {c_db}: {e}")

    # Fallback to target_db if source DBs unavailable
    if not active_keys:
        c_cur = conn.cursor(dictionary=True, buffered=True)
        c_cur.execute(f"""
            SELECT p.ProcCode, p.Descript, d.ItemName
            FROM `{target_db}`.procedurecode p
            JOIN `{target_db}`.definition d ON p.ProcCat = d.DefNum
            WHERE d.Category = 11 AND d.IsHidden = 0 AND LOWER(d.ItemName) NOT LIKE '%obat%'
        """)
        for r in c_cur.fetchall():
            norm_k = re.sub(r'[\s_]+', '', r['ProcCode'] or '').upper()
            active_keys.add(norm_k)
            if norm_k not in clinic_active_info:
                clinic_active_info[norm_k] = r
        c_cur.close()

    # 2. Fetch all procedures in target_db
    cursor.execute(f"SELECT * FROM `{target_db}`.procedurecode")
    all_target_procs = cursor.fetchall()

    act_groups = defaultdict(list)
    obs_ids = []

    for r in all_target_procs:
        k = get_norm_proc_key(r['ProcCode'], r['Descript'])
        if k in active_keys or k in ('OS_HECT', 'PROM2_BEHEL'):
            act_groups[k].append(r)
        else:
            obs_ids.append(r['CodeNum'])

    # 3. Quarantine obsolete procedure codes to HARGA LAMA (273)
    if obs_ids:
        obs_str = ','.join(str(i) for i in obs_ids)
        cursor.execute(f"""
            UPDATE `{target_db}`.procedurecode 
            SET ProcCat = 273 
            WHERE CodeNum IN ({obs_str})
        """)
        print(f"    Quarantined {len(obs_ids)} obsolete procedure codes to HARGA LAMA (DefNum 273)")

    CODE_NUM_CHILD_TABLES = [
        ("procedurelog", "CodeNum"),
        ("procbuttonitem", "CodeNum"),
        ("proccodenote", "CodeNum"),
        ("recalltrigger", "CodeNum"),
        ("autocodeitem", "CodeNum"),
        ("benefit", "CodeNum"),
        ("substitutionlink", "CodeNum"),
        ("toothgridcol", "CodeNum"),
        ("toothgriddef", "CodeNum"),
        ("resellerservice", "CodeNum"),
    ]

    total_remapped_proclogs = 0
    total_deleted_dups = 0

    # 4. Harmonize and deduplicate active groups
    for k, records in act_groups.items():
        rec_sorted = sorted(records, key=lambda x: x['CodeNum'])
        canonical_rec = rec_sorted[0]
        c_id = canonical_rec['CodeNum']

        descs = [(r['Descript'] or '').strip() for r in records if (r['Descript'] or '').strip()]
        clean_desc = max(descs, key=len) if descs else (canonical_rec['Descript'] or '')
        clean_code = to_canonical_proc_code(canonical_rec['ProcCode'], clean_desc)

        # Pick the record that provided clean_desc to also preserve its TreatArea, PaintType, and AbbrDesc
        best_rec = next((r for r in records if (r['Descript'] or '').strip() == clean_desc), canonical_rec)
        clean_treat_area = best_rec.get('TreatArea', canonical_rec.get('TreatArea', 0))
        clean_paint_type = best_rec.get('PaintType', canonical_rec.get('PaintType', 0))
        clean_abbr = best_rec.get('AbbrDesc') or canonical_rec.get('AbbrDesc') or ''

        source_entry = clinic_active_info.get(k)
        src_cat_name = source_entry['ItemName'] if source_entry else ''
        clean_cat = CAT_CLEAN_MAP.get(src_cat_name.upper(), map_category_to_canonical(src_cat_name))
        if k == 'OS_HECT':
            clean_cat = 82
        elif k == 'PROM2_BEHEL':
            clean_cat = 83

        cursor.execute(f"""
            UPDATE `{target_db}`.procedurecode 
            SET ProcCode = %s, Descript = %s, ProcCat = %s, TreatArea = %s, PaintType = %s, AbbrDesc = %s
            WHERE CodeNum = %s
        """, (clean_code, clean_desc, clean_cat, clean_treat_area, clean_paint_type, clean_abbr, c_id))

        dups = rec_sorted[1:]
        if dups:
            dup_ids = [d['CodeNum'] for d in dups]
            dup_str = ','.join(str(i) for i in dup_ids)

            # A) Remap child tables
            for tbl, col in CODE_NUM_CHILD_TABLES:
                cursor.execute(f"SHOW TABLES FROM `{target_db}` LIKE '{tbl}'")
                if cursor.fetchone():
                    cursor.execute(f"""
                        UPDATE `{target_db}`.`{tbl}` 
                        SET `{col}` = %s 
                        WHERE `{col}` IN ({dup_str})
                    """, (c_id,))
                    if tbl == 'procedurelog' and cursor.rowcount > 0:
                        total_remapped_proclogs += cursor.rowcount

            # B) Remap fee table
            for dup_id in dup_ids:
                cursor.execute(f"""
                    SELECT FeeNum, FeeSched, ClinicNum, ProvNum, Amount, ProviderShare, Bahan, Alat
                    FROM `{target_db}`.fee 
                    WHERE CodeNum = %s
                """, (dup_id,))
                dup_fees = cursor.fetchall()

                for df in dup_fees:
                    fs = df['FeeSched']
                    cl = df['ClinicNum']
                    prov = df['ProvNum']

                    cursor.execute(f"""
                        SELECT FeeNum, Amount, ProviderShare 
                        FROM `{target_db}`.fee 
                        WHERE CodeNum = %s AND FeeSched = %s AND ClinicNum = %s AND ProvNum = %s
                    """, (c_id, fs, cl, prov))
                    existing = cursor.fetchone()

                    if existing:
                        if (df['ProviderShare'] or 0) > (existing['ProviderShare'] or 0) or ((df['Amount'] or 0) > 0 and (existing['Amount'] or 0) == 0):
                            cursor.execute(f"""
                                UPDATE `{target_db}`.fee 
                                SET Amount = %s, ProviderShare = %s, Bahan = %s, Alat = %s 
                                WHERE FeeNum = %s
                            """, (df['Amount'], df['ProviderShare'], df['Bahan'], df['Alat'], existing['FeeNum']))
                        cursor.execute(f"DELETE FROM `{target_db}`.fee WHERE FeeNum = %s", (df['FeeNum'],))
                    else:
                        cursor.execute(f"UPDATE `{target_db}`.fee SET CodeNum = %s WHERE FeeNum = %s", (c_id, df['FeeNum']))

            # C) Delete duplicate procedurecode rows
            cursor.execute(f"DELETE FROM `{target_db}`.procedurecode WHERE CodeNum IN ({dup_str})")
            total_deleted_dups += len(dup_ids)

    conn.commit()
    cursor.close()
    print(f"    [OK] Harmonized {len(act_groups)} active procedure codes ({total_deleted_dups} duplicate rows deleted, {total_remapped_proclogs:,} proclogs remapped).")


def generate_clinic_procedure_catalogs(conn, target_db, clinics):
    """
    Creates and populates `clinic_def` and `clinic_procedurecode` in `target_db`.
    Harmonizes procedure categories to canonical categories (EXAM, CLEAN, CONS, ENDO,
    PERIO, PROST, COSME, IMPLANT, OS, ORTHO, PEDO, OBAT, HARGA LAMA) across all clinics.
    Populates clinic_procedurecode strictly with active procedures.
    """
    cursor = conn.cursor(dictionary=True, buffered=True)
    print("  [CATALOG] Generating harmonized per-clinic procedure and category catalogs...")

    # 1. Create clinic_def table
    cursor.execute(f"""
        CREATE TABLE IF NOT EXISTS `{target_db}`.`clinic_def` (
            ClinicNum BIGINT NOT NULL,
            DefNum BIGINT NOT NULL,
            Category INT NOT NULL,
            ItemOrder INT NOT NULL,
            ItemName VARCHAR(255) NOT NULL,
            ItemValue VARCHAR(255) DEFAULT '',
            ItemColor INT DEFAULT 0,
            IsHidden TINYINT DEFAULT 0,
            PRIMARY KEY (ClinicNum, DefNum),
            KEY (ClinicNum, ItemOrder)
        )
    """)

    # 2. Create clinic_procedurecode table
    cursor.execute(f"DROP TABLE IF EXISTS `{target_db}`.`clinic_procedurecode`")
    cursor.execute(f"""
        CREATE TABLE `{target_db}`.`clinic_procedurecode` (
          ClinicNum bigint(20) NOT NULL,
          CodeNum bigint(20) NOT NULL,
          ProcCode varchar(15) NOT NULL,
          Descript varchar(255) DEFAULT NULL,
          AbbrDesc varchar(50) DEFAULT NULL,
          ProcTime varchar(24) DEFAULT NULL,
          ProcCat bigint(20) NOT NULL,
          TreatArea tinyint(3) unsigned NOT NULL DEFAULT 0,
          NoBillIns tinyint(1) unsigned NOT NULL DEFAULT 0,
          IsProsth tinyint(1) unsigned NOT NULL DEFAULT 0,
          DefaultNote text DEFAULT NULL,
          IsHygiene tinyint(1) unsigned NOT NULL DEFAULT 0,
          GTypeNum smallint(5) unsigned NOT NULL DEFAULT 0,
          AlternateCode1 varchar(15) DEFAULT NULL,
          MedicalCode varchar(15) DEFAULT NULL,
          IsTaxed tinyint(3) unsigned NOT NULL DEFAULT 0,
          PaintType tinyint(4) NOT NULL DEFAULT 0,
          GraphicColor int(11) NOT NULL,
          LaymanTerm varchar(255) DEFAULT NULL,
          IsCanadianLab tinyint(3) unsigned NOT NULL,
          PreExisting tinyint(1) NOT NULL DEFAULT 0,
          BaseUnits int(11) NOT NULL,
          SubstitutionCode varchar(25) DEFAULT NULL,
          SubstOnlyIf int(11) NOT NULL,
          DateTStamp timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
          IsMultiVisit tinyint(4) NOT NULL,
          DrugNDC varchar(255) NOT NULL,
          RevenueCodeDefault varchar(255) NOT NULL,
          ProvNumDefault bigint(20) NOT NULL,
          CanadaTimeUnits double NOT NULL,
          IsRadiology tinyint(4) NOT NULL,
          DefaultClaimNote text NOT NULL,
          DefaultTPNote text NOT NULL,
          BypassGlobalLock tinyint(4) NOT NULL,
          TaxCode varchar(16) NOT NULL,
          PaintText varchar(255) NOT NULL,
          AreaAlsoToothRange tinyint(4) NOT NULL,
          DiagnosticCodes varchar(255) NOT NULL,
          PRIMARY KEY (ClinicNum, CodeNum),
          KEY (ClinicNum, ProcCat),
          KEY (ClinicNum, ProcCode)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci
    """)

    cursor.execute(f"TRUNCATE TABLE `{target_db}`.`clinic_def`")
    cursor.execute(f"TRUNCATE TABLE `{target_db}`.`clinic_procedurecode`")

    # 3. Create clinic_feesched table
    cursor.execute(f"""
        CREATE TABLE IF NOT EXISTS `{target_db}`.`clinic_feesched` (
            ClinicNum BIGINT NOT NULL,
            FeeSchedNum BIGINT NOT NULL,
            PRIMARY KEY (ClinicNum, FeeSchedNum),
            KEY (ClinicNum)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci
    """)
    cursor.execute(f"TRUNCATE TABLE `{target_db}`.`clinic_feesched`")

    # 4. Seed Canonical Definitions into target_db.definition
    for def_num, item_order, item_name, is_hidden in CANONICAL_PROC_CATS:
        cursor.execute(f"""
            INSERT INTO `{target_db}`.`definition`
                (DefNum, Category, ItemOrder, ItemName, ItemValue, ItemColor, IsHidden)
            VALUES (%s, 11, %s, %s, '', 0, %s)
            ON DUPLICATE KEY UPDATE ItemOrder=VALUES(ItemOrder), ItemName=VALUES(ItemName), IsHidden=VALUES(IsHidden)
        """, (def_num, item_order, item_name, is_hidden))

    # Hide all other Category 11 definitions in target_db
    canonical_visible_ids = [c[0] for c in CANONICAL_PROC_CATS if c[3] == 0]
    id_list_str = ','.join(str(i) for i in canonical_visible_ids)
    cursor.execute(f"""
        UPDATE `{target_db}`.`definition`
        SET IsHidden = 1
        WHERE Category = 11 AND DefNum NOT IN ({id_list_str})
    """)

    # 5. Query strictly active procedure codes from target_db
    cursor.execute(f"""
        SELECT * FROM `{target_db}`.`procedurecode` 
        WHERE ProcCat NOT IN (114, 273, 981)
        ORDER BY ProcCat, ProcCode
    """)
    active_procs = cursor.fetchall()

    # 6. Populate each clinic with canonical categories and active procedure codes
    for c in clinics:
        c_num = c["ClinicNum"]
        c_desc = c.get('Description', f'Clinic {c_num}')

        # Populate clinic_def with identical canonical categories
        for def_num, item_order, item_name, is_hidden in CANONICAL_PROC_CATS:
            cursor.execute(f"""
                INSERT INTO `{target_db}`.`clinic_def`
                    (ClinicNum, DefNum, Category, ItemOrder, ItemName, ItemValue, ItemColor, IsHidden)
                VALUES (%s, %s, 11, %s, %s, '', 0, %s)
            """, (c_num, def_num, item_order, item_name, is_hidden))

        # Populate clinic_procedurecode strictly with active procedures
        inserted_count = 0
        for p in active_procs:
            p_copy = dict(p)
            cols = list(p_copy.keys())
            col_str = '`, `'.join(['ClinicNum'] + cols)
            vals = [c_num] + [p_copy[k] for k in cols]
            placeholders = ', '.join(['%s'] * len(vals))
            cursor.execute(f"INSERT INTO `{target_db}`.`clinic_procedurecode` (`{col_str}`) VALUES ({placeholders})", vals)
            inserted_count += 1

        print(f"    Clinic {c_num} ({c_desc}): {len(CANONICAL_PROC_CATS)} categories, {inserted_count} procedure codes.")

    conn.commit()
    cursor.close()
    print("  [OK] Generated harmonized clinic catalogs.")


def consolidate_unified_fees(conn, target_db):
    """
    Consolidates clinic-specific fee schedules into unified JM FeeSched IDs across all clinics:
      - FeeSched 56: JM Spesialis (Visible)
      - FeeSched 57: JM Fulltimer (Visible)
      - FeeSched 58: JM Partimer (Visible)
      - FeeSched 53: Office Fees (Hidden, legacy default)
    All active procedure codes from older schedules (Full Timer, Fulltime, etc.) are merged
    into the active JM fee schedules. Provider FeeSched references are also remapped to 56, 57, 58.
    """
    cursor = conn.cursor()
    print("  [FEE] Consolidating unified JM fee schedules (FeeSched 56, 57, 58)...")

    # 1. Remap provider FeeSched to canonical JM schedules
    cursor.execute(f"UPDATE `{target_db}`.`provider` SET FeeSched = 56 WHERE FeeSched IN (2000057, 2000054, 3000060, 3000055)")
    cursor.execute(f"UPDATE `{target_db}`.`provider` SET FeeSched = 57 WHERE FeeSched IN (2000055, 2000053, 3000058, 3000054, 3000056, 3000057)")
    cursor.execute(f"UPDATE `{target_db}`.`provider` SET FeeSched = 58 WHERE FeeSched IN (2000056, 3000059)")
    cursor.execute(f"UPDATE `{target_db}`.`patient` SET FeeSched = 56 WHERE FeeSched IN (2000057, 2000054, 3000060, 3000055)")
    cursor.execute(f"UPDATE `{target_db}`.`patient` SET FeeSched = 57 WHERE FeeSched IN (2000055, 2000053, 3000058, 3000054, 3000056, 3000057)")
    cursor.execute(f"UPDATE `{target_db}`.`patient` SET FeeSched = 58 WHERE FeeSched IN (2000056, 3000059)")

    # 2. Update primary JM fees in `fee` table
    # Clinic 2 (Boyolali)
    cursor.execute(f"UPDATE `{target_db}`.`fee` SET FeeSched = 56 WHERE FeeSched = 2000057 AND ClinicNum = 2")
    cursor.execute(f"UPDATE `{target_db}`.`fee` SET FeeSched = 57 WHERE FeeSched = 2000055 AND ClinicNum = 2")
    cursor.execute(f"UPDATE `{target_db}`.`fee` SET FeeSched = 58 WHERE FeeSched = 2000056 AND ClinicNum = 2")

    # Clinic 3 (Jogja)
    cursor.execute(f"UPDATE `{target_db}`.`fee` SET FeeSched = 56 WHERE FeeSched = 3000060 AND ClinicNum = 3")
    cursor.execute(f"UPDATE `{target_db}`.`fee` SET FeeSched = 57 WHERE FeeSched = 3000058 AND ClinicNum = 3")
    cursor.execute(f"UPDATE `{target_db}`.`fee` SET FeeSched = 58 WHERE FeeSched = 3000059 AND ClinicNum = 3")

    # 3. Merge legacy Fulltime / Fulltimer fees into JM Fulltimer (57), JM Partimer (58), JM Spesialis (56)
    # Clinic 2: Merge 2000053 (Fulltime)
    cursor.execute(f"""
        INSERT INTO `{target_db}`.`fee` (Amount, FeeSched, CodeNum, ClinicNum, ProvNum, ProviderShare, Bahan, Alat)
        SELECT f.Amount, 57, f.CodeNum, 2, f.ProvNum, f.ProviderShare, f.Bahan, f.Alat
        FROM `{target_db}`.`fee` f
        WHERE f.ClinicNum = 2 AND f.FeeSched = 2000053 AND f.Amount > 0
        AND f.CodeNum NOT IN (
            SELECT f57.CodeNum FROM (SELECT CodeNum FROM `{target_db}`.`fee` WHERE ClinicNum = 2 AND FeeSched = 57) f57
        )
        ON DUPLICATE KEY UPDATE Amount = VALUES(Amount)
    """)
    cursor.execute(f"""
        INSERT INTO `{target_db}`.`fee` (Amount, FeeSched, CodeNum, ClinicNum, ProvNum, ProviderShare, Bahan, Alat)
        SELECT f.Amount, 58, f.CodeNum, 2, f.ProvNum, 
               CASE WHEN f.ProviderShare > 0 THEN f.ProviderShare * 1.33 ELSE 0 END, 
               f.Bahan, f.Alat
        FROM `{target_db}`.`fee` f
        WHERE f.ClinicNum = 2 AND f.FeeSched = 57 AND f.Amount > 0
        AND f.CodeNum NOT IN (
            SELECT f58.CodeNum FROM (SELECT CodeNum FROM `{target_db}`.`fee` WHERE ClinicNum = 2 AND FeeSched = 58) f58
        )
        ON DUPLICATE KEY UPDATE Amount = VALUES(Amount)
    """)
    cursor.execute(f"""
        INSERT INTO `{target_db}`.`fee` (Amount, FeeSched, CodeNum, ClinicNum, ProvNum, ProviderShare, Bahan, Alat)
        SELECT f.Amount, 56, f.CodeNum, 2, f.ProvNum, f.ProviderShare, f.Bahan, f.Alat
        FROM `{target_db}`.`fee` f
        WHERE f.ClinicNum = 2 AND f.FeeSched = 57 AND f.Amount > 0
        AND f.CodeNum NOT IN (
            SELECT f56.CodeNum FROM (SELECT CodeNum FROM `{target_db}`.`fee` WHERE ClinicNum = 2 AND FeeSched = 56) f56
        )
        ON DUPLICATE KEY UPDATE Amount = VALUES(Amount)
    """)

    # Clinic 3: Merge 3000054 (Fulltimer) and 3000053
    cursor.execute(f"""
        INSERT INTO `{target_db}`.`fee` (Amount, FeeSched, CodeNum, ClinicNum, ProvNum, ProviderShare, Bahan, Alat)
        SELECT f.Amount, 57, f.CodeNum, 3, f.ProvNum, f.ProviderShare, f.Bahan, f.Alat
        FROM `{target_db}`.`fee` f
        WHERE f.ClinicNum = 3 AND f.FeeSched IN (3000053, 3000054) AND f.Amount > 0
        AND f.CodeNum NOT IN (
            SELECT f57.CodeNum FROM (SELECT CodeNum FROM `{target_db}`.`fee` WHERE ClinicNum = 3 AND FeeSched = 57) f57
        )
        ON DUPLICATE KEY UPDATE Amount = VALUES(Amount)
    """)
    cursor.execute(f"""
        INSERT INTO `{target_db}`.`fee` (Amount, FeeSched, CodeNum, ClinicNum, ProvNum, ProviderShare, Bahan, Alat)
        SELECT f.Amount, 58, f.CodeNum, 3, f.ProvNum, f.ProviderShare, f.Bahan, f.Alat
        FROM `{target_db}`.`fee` f
        WHERE f.ClinicNum = 3 AND f.FeeSched = 57 AND f.Amount > 0
        AND f.CodeNum NOT IN (
            SELECT f58.CodeNum FROM (SELECT CodeNum FROM `{target_db}`.`fee` WHERE ClinicNum = 3 AND FeeSched = 58) f58
        )
        ON DUPLICATE KEY UPDATE Amount = VALUES(Amount)
    """)
    cursor.execute(f"""
        INSERT INTO `{target_db}`.`fee` (Amount, FeeSched, CodeNum, ClinicNum, ProvNum, ProviderShare, Bahan, Alat)
        SELECT f.Amount, 56, f.CodeNum, 3, f.ProvNum, f.ProviderShare, f.Bahan, f.Alat
        FROM `{target_db}`.`fee` f
        WHERE f.ClinicNum = 3 AND f.FeeSched = 57 AND f.Amount > 0
        AND f.CodeNum NOT IN (
            SELECT f56.CodeNum FROM (SELECT CodeNum FROM `{target_db}`.`fee` WHERE ClinicNum = 3 AND FeeSched = 56) f56
        )
        ON DUPLICATE KEY UPDATE Amount = VALUES(Amount)
    """)

    # Clinic 1: Merge 54 (Full Timer)
    cursor.execute(f"""
        INSERT INTO `{target_db}`.`fee` (Amount, FeeSched, CodeNum, ClinicNum, ProvNum, ProviderShare, Bahan, Alat)
        SELECT f.Amount, 57, f.CodeNum, 1, f.ProvNum, f.ProviderShare, f.Bahan, f.Alat
        FROM `{target_db}`.`fee` f
        WHERE f.ClinicNum = 1 AND f.FeeSched = 54 AND f.Amount > 0
        AND f.CodeNum NOT IN (
            SELECT f57.CodeNum FROM (SELECT CodeNum FROM `{target_db}`.`fee` WHERE ClinicNum = 1 AND FeeSched = 57) f57
        )
        ON DUPLICATE KEY UPDATE Amount = VALUES(Amount)
    """)
    cursor.execute(f"""
        INSERT INTO `{target_db}`.`fee` (Amount, FeeSched, CodeNum, ClinicNum, ProvNum, ProviderShare, Bahan, Alat)
        SELECT f.Amount, 58, f.CodeNum, 1, f.ProvNum, 
               CASE WHEN f.ProviderShare > 0 THEN f.ProviderShare * 1.33 ELSE 0 END, 
               f.Bahan, f.Alat
        FROM `{target_db}`.`fee` f
        WHERE f.ClinicNum = 1 AND f.FeeSched = 57 AND f.Amount > 0
        AND f.CodeNum NOT IN (
            SELECT f58.CodeNum FROM (SELECT CodeNum FROM `{target_db}`.`fee` WHERE ClinicNum = 1 AND FeeSched = 58) f58
        )
        ON DUPLICATE KEY UPDATE Amount = VALUES(Amount)
    """)
    cursor.execute(f"""
        INSERT INTO `{target_db}`.`fee` (Amount, FeeSched, CodeNum, ClinicNum, ProvNum, ProviderShare, Bahan, Alat)
        SELECT f.Amount, 56, f.CodeNum, 1, f.ProvNum, f.ProviderShare, f.Bahan, f.Alat
        FROM `{target_db}`.`fee` f
        WHERE f.ClinicNum = 1 AND f.FeeSched = 57 AND f.Amount > 0
        AND f.CodeNum NOT IN (
            SELECT f56.CodeNum FROM (SELECT CodeNum FROM `{target_db}`.`fee` WHERE ClinicNum = 1 AND FeeSched = 56) f56
        )
        ON DUPLICATE KEY UPDATE Amount = VALUES(Amount)
    """)

    # 4. Clean up FeeSched 53 (Office Fees) - remove clinic overrides and hide it
    cursor.execute(f"DELETE FROM `{target_db}`.`fee` WHERE FeeSched = 53 AND ClinicNum > 0")
    cursor.execute(f"UPDATE `{target_db}`.`feesched` SET Description = 'Office Fees', IsHidden = 1 WHERE FeeSchedNum = 53")
    cursor.execute(f"UPDATE `{target_db}`.`feesched` SET Description = 'JM Spesialis', IsHidden = 0 WHERE FeeSchedNum = 56")
    cursor.execute(f"UPDATE `{target_db}`.`feesched` SET Description = 'JM Fulltimer', IsHidden = 0 WHERE FeeSchedNum = 57")
    cursor.execute(f"UPDATE `{target_db}`.`feesched` SET Description = 'JM Partimer', IsHidden = 0 WHERE FeeSchedNum = 58")
    cursor.execute(f"UPDATE `{target_db}`.`feesched` SET IsHidden = 1 WHERE FeeSchedNum NOT IN (56, 57, 58)")

    # Clean any leftover [TAG] prefixes
    cursor.execute(f"""
        UPDATE `{target_db}`.`feesched` 
        SET Description = CASE 
            WHEN Description LIKE '[%]%' THEN TRIM(SUBSTRING(Description, INSTR(Description, ']') + 1))
            ELSE Description 
        END
        WHERE Description LIKE '[%]%'
    """)

    # Deduplicate fee table rows where exact duplicate exists
    cursor.execute(f"""
        DELETE f1 FROM `{target_db}`.`fee` f1
        JOIN `{target_db}`.`fee` f2 ON f1.FeeSched = f2.FeeSched 
                   AND f1.CodeNum = f2.CodeNum 
                   AND f1.ClinicNum = f2.ClinicNum 
                   AND f1.ProvNum = f2.ProvNum 
                   AND (f1.ProviderShare < f2.ProviderShare 
                        OR (f1.ProviderShare = f2.ProviderShare AND f1.Amount <= f2.Amount AND f1.FeeNum > f2.FeeNum))
    """)

    # 5. Populate clinic_feesched (strictly 56, 57, 58 for all clinics)
    cursor.execute(f"TRUNCATE TABLE `{target_db}`.`clinic_feesched`")
    for c_num in [1, 2, 3]:
        for fs_num in [56, 57, 58]:
            cursor.execute(f"INSERT IGNORE INTO `{target_db}`.`clinic_feesched` (ClinicNum, FeeSchedNum) VALUES (%s, %s)", (c_num, fs_num))

    conn.commit()
    cursor.close()
    print("  [OK] Unified JM fee schedules (56, 57, 58) consolidated and populated.")


def seed_baseline_fees(conn, target_db):
    """
    Inserts baseline ClinicNum = 0 fee records for unified fee schedules (56, 57, 58).
    This guarantees that when the client queries fees with Default/0 clinic override,
    the fee amount is found rather than returning 0.
    """
    cursor = conn.cursor()
    print("  [FEE] Seeding baseline fees (ClinicNum = 0) for unified fee schedules...")
    cursor.execute(f"""
        INSERT IGNORE INTO `{target_db}`.`fee` (Amount, FeeSched, CodeNum, ClinicNum, ProvNum, ProviderShare, Bahan, Alat)
        SELECT Amount, FeeSched, CodeNum, 0, ProvNum, ProviderShare, Bahan, Alat
        FROM `{target_db}`.`fee`
        WHERE ClinicNum = 1 AND FeeSched IN (56, 57, 58)
    """)
    if cursor.rowcount > 0:
        print(f"  [FIX] Inserted {cursor.rowcount} baseline ClinicNum = 0 fee records from Clinic 1.")

    # Deduplicate any duplicate ClinicNum = 0 records
    cursor.execute(f"""
        DELETE f1 FROM `{target_db}`.`fee` f1
        JOIN `{target_db}`.`fee` f2 ON f1.FeeSched = f2.FeeSched 
                   AND f1.CodeNum = f2.CodeNum 
                   AND f1.ClinicNum = 0 
                   AND f2.ClinicNum = 0 
                   AND f1.ProvNum = f2.ProvNum 
                   AND (f1.ProviderShare < f2.ProviderShare 
                        OR (f1.ProviderShare = f2.ProviderShare AND f1.Amount <= f2.Amount AND f1.FeeNum > f2.FeeNum))
    """)
    conn.commit()
    cursor.close()
    print("  [OK] Baseline fees synchronized.")


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
        ("procedurelog.CodeNum -> procedurecode.CodeNum", f"SELECT COUNT(*) FROM `{target_db}`.`procedurelog` WHERE CodeNum > 0 AND CodeNum NOT IN (SELECT CodeNum FROM `{target_db}`.`procedurecode`)"),
        ("fee.CodeNum -> procedurecode.CodeNum", f"SELECT COUNT(*) FROM `{target_db}`.`fee` WHERE CodeNum > 0 AND CodeNum NOT IN (SELECT CodeNum FROM `{target_db}`.`procedurecode`)"),
        ("fee.FeeSched -> feesched.FeeSchedNum", f"SELECT COUNT(*) FROM `{target_db}`.`fee` WHERE FeeSched > 0 AND FeeSched NOT IN (SELECT FeeSchedNum FROM `{target_db}`.`feesched`)"),
        ("provider.FeeSched -> feesched.FeeSchedNum", f"SELECT COUNT(*) FROM `{target_db}`.`provider` WHERE FeeSched > 0 AND FeeSched NOT IN (SELECT FeeSchedNum FROM `{target_db}`.`feesched`)"),
        ("payment.PayType -> definition.DefNum", f"SELECT COUNT(*) FROM `{target_db}`.`payment` WHERE PayType > 0 AND PayType NOT IN (SELECT DefNum FROM `{target_db}`.`definition`)"),
        ("adjustment.AdjType -> definition.DefNum", f"SELECT COUNT(*) FROM `{target_db}`.`adjustment` WHERE AdjType > 0 AND AdjType NOT IN (SELECT DefNum FROM `{target_db}`.`definition`)"),
        ("document.DocCategory -> definition.DefNum", f"SELECT COUNT(*) FROM `{target_db}`.`document` WHERE DocCategory > 0 AND DocCategory NOT IN (SELECT DefNum FROM `{target_db}`.`definition`)"),
        ("patient.EmployerNum -> employer.EmployerNum", f"SELECT COUNT(*) FROM `{target_db}`.`patient` WHERE EmployerNum > 0 AND EmployerNum NOT IN (SELECT EmployerNum FROM `{target_db}`.`employer`)"),
        ("sheetfielddef.SheetDefNum -> sheetdef.SheetDefNum", f"SELECT COUNT(*) FROM `{target_db}`.`sheetfielddef` WHERE SheetDefNum > 0 AND SheetDefNum NOT IN (SELECT SheetDefNum FROM `{target_db}`.`sheetdef`)"),
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
                {"ClinicNum": 1, "db": src_klt, "Description": "Klaten 1", "Abbr": "KLT", "ExternalID": 1},
                {"ClinicNum": 2, "db": src_byl, "Description": "Boyolali 1", "Abbr": "BYL", "ExternalID": 2},
                {"ClinicNum": 3, "db": src_jog, "Description": "Jogja 1", "Abbr": "JOG", "ExternalID": 3},
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

    # Clinic 1 fee schedules preserve original descriptions (isolated by clinic_feesched)

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
            try:
                conn.commit()
                create_cur = conn.cursor()
                create_cur.execute(f"CREATE DATABASE `{tmp_db}` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;")
                create_cur.close()
                conn.commit()
            except Exception as cex:
                debug_log(f"In-process create db fallback ({cex})...")
                run_shell_cmd(f'"{mysql_exe}" -h {args.host} -P {args.port} -u {db_user} -e "CREATE DATABASE `{tmp_db}` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;"', env_vars=child_env, timeout=30)

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

            print(f"  Harmonizing Catalogs (procedurecode & definition) `{tmp_db}` -> `{target_db}`...")
            try:
                from harmonize_catalogs import harmonize_procedurecodes, harmonize_definitions
                harmonize_procedurecodes(conn, src_db=tmp_db, target_db=target_db)
                harmonize_definitions(conn, src_db=tmp_db, target_db=target_db)
            except Exception as hex:
                print(f"  [ERROR] Harmonization failed: {hex}")
                raise

            print(f"  Applying PK/FK offset +{actual_offset:,} to `{tmp_db}`...")
            try:
                from offset_db import run_offset
                run_offset(actual_offset, db=tmp_db, conn=conn)
            except Exception as ex:
                debug_log(f"In-process offset fallback ({ex})...")
                run_shell_cmd(f'"{python_exe}" "{OFFSET_SCRIPT}" {actual_offset} --db {tmp_db}', env_vars=child_env, print_stdout=True)

            # Subsequent clinic fee schedules preserve original descriptions (isolated by clinic_feesched)

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
                try:
                    conn.commit()
                except Exception:
                    pass

                dropped = False
                try:
                    drop_cur = conn.cursor()
                    drop_cur.execute("SET lock_wait_timeout = 5")
                    drop_cur.execute(f"DROP DATABASE IF EXISTS `{tmp_db}`")
                    drop_cur.close()
                    conn.commit()
                    dropped = True
                    print(f"  [OK] Cleaned up temporary DB `{tmp_db}`.")
                except Exception as dex:
                    debug_log(f"In-process drop failed ({dex}), trying fallback...")

                if not dropped:
                    try:
                        run_shell_cmd(f'"{mysql_exe}" -h {args.host} -P {args.port} -u {db_user} -e "DROP DATABASE IF EXISTS `{tmp_db}`;"', env_vars=child_env, check=False, timeout=30)
                        print(f"  [OK] Cleaned up temporary DB `{tmp_db}` via mysql.exe.")
                    except Exception as mex:
                        print(f"  [WARN] Could not drop temporary DB `{tmp_db}`: {mex}")
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

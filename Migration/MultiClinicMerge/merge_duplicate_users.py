"""
Dynamic User Merge & Deduplication Tool
======================================
Detects and merges duplicate usernames across merged clinic databases:
  - Dynamically discovers all duplicate usernames (case-insensitive) in userod
  - Selects the primary account (prefers non-hidden and most active in securitylog)
  - Remaps all foreign key references across all tables to the primary account
  - Consolidates clinic access (userclinic), groups (usergroupattach), and apptviews (userodapptview)
  - Deletes the duplicate userod records
  - No hardcoded IDs or credentials
"""

import os
import sys
import argparse
import subprocess

def _find_repo_root(start_dir):
    cur = os.path.abspath(start_dir)
    while True:
        if os.path.exists(os.path.join(cur, ".venv")) or os.path.exists(os.path.join(cur, "Helianz.sln")):
            return cur
        parent = os.path.dirname(cur)
        if parent == cur:
            break
        cur = parent
    return os.path.dirname(os.path.dirname(os.path.abspath(start_dir)))

# Auto-detect and switch to project virtual environment if mysql.connector is missing
try:
    import mysql.connector
except ImportError:
    _script_dir = os.path.dirname(os.path.abspath(__file__))
    _repo_root = _find_repo_root(_script_dir)
    _venv_python = os.path.join(_repo_root, ".venv", "Scripts", "python.exe")
    if os.path.exists(_venv_python) and os.path.normpath(sys.executable).lower() != os.path.normpath(_venv_python).lower():
        _result = subprocess.run([_venv_python] + sys.argv)
        sys.exit(_result.returncode)
    else:
        _venv_site = os.path.join(_repo_root, ".venv", "Lib", "site-packages")
        if os.path.exists(_venv_site) and _venv_site not in sys.path:
            sys.path.insert(0, _venv_site)
        try:
            import mysql.connector
        except ImportError:
            sys.exit(
                "Error: 'mysql-connector-python' is not installed in the active Python environment.\n"
                f"Please run with the project virtual environment:\n"
                f"  {_venv_python} {' '.join(sys.argv)}\n"
            )

# Ensure UTF-8 output on Windows console
if sys.platform == "win32":
    try:
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
        sys.stderr.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass

LINKING_TABLES = {"userclinic", "usergroupattach", "userodapptview", "userodpref", "alertsub"}


def get_all_usernum_columns(cursor, db):
    """Discover all tables and columns that reference UserNum."""
    cursor.execute("""
        SELECT TABLE_NAME, COLUMN_NAME 
        FROM information_schema.COLUMNS 
        WHERE TABLE_SCHEMA = %s 
          AND (COLUMN_NAME LIKE '%usernum%' OR COLUMN_NAME = 'UserNum') 
          AND DATA_TYPE = 'bigint'
    """, (db,))
    return cursor.fetchall()


def merge_duplicate_users(conn, db):
    """
    Dynamically merges all duplicate usernames in the specified database.
    Can be called directly with an existing MySQL connection or via CLI.
    """
    cursor = conn.cursor(buffered=True)
    cursor.execute(f"USE `{db}`")

    # 1. Find all duplicate usernames (case-insensitive)
    cursor.execute("""
        SELECT LOWER(TRIM(UserName)) AS norm_name, COUNT(*) AS cnt, GROUP_CONCAT(UserNum ORDER BY UserNum) AS all_ids
        FROM userod
        GROUP BY LOWER(TRIM(UserName))
        HAVING cnt > 1
    """)
    duplicates = cursor.fetchall()

    if not duplicates:
        print("  [USERS] No duplicate usernames found.")
        cursor.close()
        return

    print(f"\n  [USERS] Found {len(duplicates)} duplicate username group(s):")

    all_user_cols = get_all_usernum_columns(cursor, db)

    for norm_name, cnt, all_ids_str in duplicates:
        user_ids = [int(x) for x in all_ids_str.split(",")]
        
        # Pick the best primary UserNum:
        # Prefer non-hidden, then most security logs, then lowest UserNum
        best_user_id = user_ids[0]
        max_score = -1

        user_info = []
        for uid in user_ids:
            cursor.execute("SELECT UserName, IsHidden FROM userod WHERE UserNum = %s", (uid,))
            row = cursor.fetchone()
            if not row:
                continue
            uname, is_hidden = row[0], row[1]

            cursor.execute("SELECT COUNT(*) FROM securitylog WHERE UserNum = %s", (uid,))
            log_count = cursor.fetchone()[0]

            # Score: non-hidden gets +1,000,000, plus actual log count
            score = (0 if is_hidden else 1_000_000) + log_count
            user_info.append((uid, uname, is_hidden, log_count, score))

            if score > max_score:
                max_score = score
                best_user_id = uid

        # Find the canonical username string (prefer proper case from primary)
        canonical_name = next(u[1] for u in user_info if u[0] == best_user_id)
        other_ids = [uid for uid in user_ids if uid != best_user_id]

        print(f"\n  Merging '{canonical_name}' (Primary: UserNum={best_user_id}, merging from: {other_ids}):")

        for from_id in other_ids:
            # Transfer clinic access
            cursor.execute(f"""
                INSERT IGNORE INTO userclinic (UserNum, ClinicNum)
                SELECT {best_user_id}, ClinicNum FROM userclinic WHERE UserNum = {from_id}
            """)
            cursor.execute(f"DELETE FROM userclinic WHERE UserNum = {from_id}")

            # Transfer user groups
            cursor.execute(f"""
                INSERT IGNORE INTO usergroupattach (UserNum, UserGroupNum)
                SELECT {best_user_id}, UserGroupNum FROM usergroupattach WHERE UserNum = {from_id}
            """)
            cursor.execute(f"DELETE FROM usergroupattach WHERE UserNum = {from_id}")

            # Transfer apptviews
            cursor.execute(f"""
                INSERT IGNORE INTO userodapptview (UserNum, ClinicNum, ApptViewNum)
                SELECT {best_user_id}, ClinicNum, ApptViewNum FROM userodapptview WHERE UserNum = {from_id}
            """)
            cursor.execute(f"DELETE FROM userodapptview WHERE UserNum = {from_id}")

            # Clean up userodpref & alertsub for duplicate
            cursor.execute(f"DELETE FROM userodpref WHERE UserNum = {from_id}")
            cursor.execute(f"DELETE FROM alertsub WHERE UserNum = {from_id}")

            # Remap all foreign keys across data tables
            for tbl, col in all_user_cols:
                if tbl in LINKING_TABLES or tbl == "userod":
                    continue
                try:
                    cursor.execute(f"UPDATE `{tbl}` SET `{col}` = {best_user_id} WHERE `{col}` = {from_id}")
                    if cursor.rowcount > 0:
                        print(f"    Remapped {tbl}.{col}: {cursor.rowcount} rows -> UserNum {best_user_id}")
                except Exception as e:
                    print(f"    Error updating {tbl}.{col}: {e}")

            # Delete the duplicate userod record
            cursor.execute(f"DELETE FROM userod WHERE UserNum = {from_id}")
            print(f"    Deleted duplicate userod record (UserNum={from_id})")

        # Normalize primary username
        cursor.execute("UPDATE userod SET UserName = %s WHERE UserNum = %s", (canonical_name, best_user_id))

    # Ensure clean deduplication of linking tables
    cursor.execute("""
        DELETE uc1 FROM userclinic uc1
        INNER JOIN userclinic uc2
        WHERE uc1.UserNum = uc2.UserNum AND uc1.ClinicNum = uc2.ClinicNum AND uc1.UserClinicNum > uc2.UserClinicNum
    """)
    cursor.execute("""
        DELETE uav1 FROM userodapptview uav1
        INNER JOIN userodapptview uav2
        WHERE uav1.UserNum = uav2.UserNum AND uav1.ClinicNum = uav2.ClinicNum AND uav1.UserodApptViewNum > uav2.UserodApptViewNum
    """)
    cursor.execute("""
        DELETE uga1 FROM usergroupattach uga1
        INNER JOIN usergroupattach uga2
        WHERE uga1.UserNum = uga2.UserNum AND uga1.UserGroupNum = uga2.UserGroupNum AND uga1.UserGroupAttachNum > uga2.UserGroupAttachNum
    """)

    conn.commit()
    cursor.close()
    print("  [USERS] User merge and deduplication completed successfully.")


def main():
    import getpass
    parser = argparse.ArgumentParser(description="Merge duplicate users in Helianz database")
    parser.add_argument("--db", default="helianz", help="Database name (default: helianz)")
    parser.add_argument("--host", default="localhost", help="Database host (default: localhost)")
    parser.add_argument("--port", type=int, default=3306, help="Database port (default: 3306)")
    parser.add_argument("--user", default="root", help="Database user (default: root)")
    parser.add_argument("--password", default=None, help="Database password (prompted if omitted)")
    args = parser.parse_args()

    password = args.password
    if password is None:
        password = os.environ.get("MYSQL_PWD")
    if password is None:
        password = getpass.getpass(f"Enter MariaDB password for user '{args.user}': ")

    conn = mysql.connector.connect(
        host=args.host,
        port=args.port,
        user=args.user,
        password=password,
        database=args.db,
        charset="utf8mb4",
        use_pure=True,
        ssl_disabled=True,
        connection_timeout=30,
    )
    merge_duplicate_users(conn, args.db)
    conn.close()


if __name__ == "__main__":
    main()

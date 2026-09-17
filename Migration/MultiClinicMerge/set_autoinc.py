"""
After merging clinics, set all clinic-table AUTO_INCREMENT values
to start from a safe slot above all historical PK ranges.

Usage:
  python set_autoinc.py --db helianz_klaten --start 20000000
  python set_autoinc.py --db helianz_klaten --start 20000000 --dry-run
"""
import mysql.connector
import os
import argparse
import sys

HOST = os.environ.get("MYSQL_HOST", "localhost")
PORT = int(os.environ.get("MYSQL_TCP_PORT", "3306"))
USER = os.environ.get("MYSQL_USER", "root")
PASSWORD = os.environ.get("MYSQL_PWD", "J0k0m4r0k3@")


def get_db_connection(db=None, host=None, port=None, user=None, password=None):
    """Create a MariaDB/MySQL connection with pure-Python mode to avoid Windows C-extension access violations."""
    h = host or HOST
    p = port or PORT
    u = user or USER
    pwd = password if password is not None else PASSWORD
    for use_pure in [True, False]:
        try:
            return mysql.connector.connect(
                host=h,
                port=p,
                user=u,
                password=pwd,
                database=db,
                use_pure=use_pure,
                ssl_disabled=True,
                connection_timeout=30,
                charset="utf8mb4"
            )
        except Exception:
            if not use_pure:
                raise

# Shared PK names that should NOT be bumped (reference tables)
SHARED_PK_NAMES = {
    'clinicnum', 'defnum', 'provnum', 'codenum', 'feeschednum',
    'carriernum', 'employernum', 'planum', 'inssubnum',
    'icd9num', 'icd10num', 'cptnum', 'hcpcsnum', 'cdcrecnum',
    'autocodenum', 'codesystemnum', 'codegroupnum', 'cvtnum',
    'diseasedefnum', 'allergydefnum', 'medicationpatnum',
    'drugmanufacturernum', 'drugunitnum', 'evalcriteriondefnum',
    'evaluationdefnum', 'gradingscalenum', 'imagingdevicenum',
    'language', 'eclipboardsheetdefnum', 'eformdefnum',
    'emailhostingtemplatenum', 'eroutingdefnum', 'hl7defnum',
    'labcasenum', 'medlabnum',
}


def set_auto_increment(db, start_val, conn=None, dry_run=False, host=None, port=None, user=None, password=None):
    owns_conn = False
    if conn is None:
        conn = get_db_connection(db=db, host=host, port=port, user=user, password=password)
        owns_conn = True

    c = conn.cursor()

    # Get all auto_increment columns with their current AI value
    c.execute("""
        SELECT c.TABLE_NAME, c.COLUMN_NAME, t.AUTO_INCREMENT
        FROM information_schema.COLUMNS c
        JOIN information_schema.TABLES t
          ON t.TABLE_SCHEMA = c.TABLE_SCHEMA AND t.TABLE_NAME = c.TABLE_NAME
        WHERE c.TABLE_SCHEMA = %s
          AND c.EXTRA LIKE '%auto_increment%%'
        ORDER BY c.TABLE_NAME
    """, (db,))

    updated = 0
    skipped_shared = 0
    skipped_below = 0

    for table_name, col_name, current_ai in c.fetchall():
        col_lower = col_name.lower()

        # Skip shared reference PKs
        if col_lower in SHARED_PK_NAMES:
            skipped_shared += 1
            continue

        # Skip if current AI is already >= start_val
        ai = current_ai or 0
        if ai >= start_val:
            skipped_below += 1
            continue

        try:
            if dry_run:
                print(f"  [DRY] {table_name}.{col_name}: {ai:,} -> {start_val:,}", flush=True)
            else:
                c2 = conn.cursor()
                c2.execute(f"ALTER TABLE `{table_name}` AUTO_INCREMENT = {start_val}")
                c2.close()
            updated += 1
        except Exception as e:
            print(f"  ERROR {table_name}.{col_name}: {e}", file=sys.stderr, flush=True)

    conn.commit()
    c.close()
    if owns_conn:
        conn.close()

    print(f"\nUpdated: {updated} tables", flush=True)
    print(f"Skipped (shared PKs): {skipped_shared}", flush=True)
    print(f"Skipped (already >= {start_val:,}): {skipped_below}", flush=True)
    
    if dry_run:
        print("⚠️  DRY RUN — no changes made", flush=True)
    else:
        print("\n[OK] AUTO_INCREMENT update completed.", flush=True)


def main():
    parser = argparse.ArgumentParser(
        description="Set AUTO_INCREMENT to safe slot above all historical PKs")
    parser.add_argument("--db", required=True, help="Target database")
    parser.add_argument("--start", type=int, required=True,
                        help="Start auto_increment from this value (e.g., 20000000)")
    parser.add_argument("--host", default=HOST, help=f"Database host (default: {HOST})")
    parser.add_argument("--port", type=int, default=PORT, help=f"Database port (default: {PORT})")
    parser.add_argument("--user", default=USER, help=f"Database user (default: {USER})")
    parser.add_argument("--password", default=None, help="Database password (defaults to MYSQL_PWD)")
    parser.add_argument("--dry-run", action="store_true", help="Preview only")
    args = parser.parse_args()

    print(f"Database: {args.db}", flush=True)
    print(f"New auto_increment start: {args.start:,}", flush=True)
    print(flush=True)

    set_auto_increment(args.db, args.start, dry_run=args.dry_run, host=args.host, port=args.port, user=args.user, password=args.password)


if __name__ == "__main__":
    main()

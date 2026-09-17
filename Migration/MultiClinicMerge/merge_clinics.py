"""
Merge multiple temp clinic DBs into a target database.
Auto-discovers which tables to merge (ClinicNum tables + PatNum shared tables).

Usage:
  python merge_clinics.py --target heliantmp_merged --sources heliantmp_1,heliantmp_2,heliantmp_3
  python merge_clinics.py --target helianz --sources helianz_jogja_import,helianz_byl_import --dry-run
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


def discover_merge_tables(db, conn=None, host=None, port=None, user=None, password=None):
    """Return ALL tables from the source DB.
    We merge everything using INSERT IGNORE — truly shared tables (definitions, 
    procedure codes, etc.) have non-offset PKs and will be skipped on duplicate key.
    Clinic-specific and clinic-adjacent tables have offset PKs and will insert cleanly."""
    owns_conn = False
    if conn is None:
        conn = get_db_connection(db=db, host=host, port=port, user=user, password=password)
        owns_conn = True
    c = conn.cursor()
    c.execute("SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_SCHEMA = %s AND TABLE_TYPE = 'BASE TABLE' ORDER BY TABLE_NAME", (db,))
    tables = [row[0] for row in c.fetchall()]
    c.close()
    if owns_conn:
        conn.close()
    print(f"  Merging all {len(tables)} tables", flush=True)
    return tables


def merge_tables(conn, src_db, target_db, tables, dry_run=False):
    """Copy all rows from src_db tables into target_db."""
    c = conn.cursor()
    total = 0
    errors = []

    for table in tables:
        try:
            c.execute(f"SELECT COUNT(*) FROM {src_db}.`{table}`")
            cnt = c.fetchone()[0]
            if cnt == 0:
                continue

            c.execute(f"""
                SELECT COLUMN_NAME FROM information_schema.COLUMNS 
                WHERE TABLE_SCHEMA='{src_db}' AND TABLE_NAME='{table}' 
                ORDER BY ORDINAL_POSITION
            """)
            cols = [r[0] for r in c.fetchall()]
            if not cols:
                continue

            col_list = "`, `".join(cols)
            sql = f"INSERT IGNORE INTO `{target_db}`.`{table}` (`{col_list}`) SELECT `{col_list}` FROM `{src_db}`.`{table}`"

            if dry_run:
                print(f"  [DRY] {table}: {cnt} rows")
            else:
                c.execute(sql)
                rows = c.rowcount
                total += rows
                if rows > 0:
                    print(f"  {table}: {rows} rows")
        except Exception as e:
            errors.append(f"  {table}: {e}")

    c.close()
    return total, errors


def verify(target_db, conn=None, host=None, port=None, user=None, password=None):
    """Quick integrity check on the merged DB."""
    owns_conn = False
    if conn is None:
        conn = get_db_connection(db=target_db, host=host, port=port, user=user, password=password)
        owns_conn = True

    c = conn.cursor(buffered=True)

    c.execute("SELECT ClinicNum, COUNT(*) FROM patient GROUP BY ClinicNum ORDER BY ClinicNum")
    clinics = c.fetchall()
    print(f"\n  Patients: {sum(r[1] for r in clinics)} total across {len(clinics)} clinics", flush=True)
    for r in clinics:
        print(f"    ClinicNum={r[0]}: {r[1]}", flush=True)

    checks = [
        ("proc->pat", "PatNum", "patient", "PatNum"),
        ("apt->pat", "PatNum", "patient", "PatNum"),
        ("apt->op", "Op", "operatory", "OperatoryNum"),
        ("split->pat", "PatNum", "patient", "PatNum"),
        ("pay->pat", "PatNum", "patient", "PatNum"),
    ]
    all_ok = True
    for label, fc, pt, pc in checks:
        # Find which table has this FK
        c.execute(f"""
            SELECT TABLE_NAME FROM information_schema.COLUMNS 
            WHERE TABLE_SCHEMA='{target_db}' AND COLUMN_NAME='{fc}'
            LIMIT 1
        """)
        ft_row = c.fetchone()
        if not ft_row:
            continue
        ft = ft_row[0]
        c.execute(f"SELECT COUNT(*) FROM `{ft}` WHERE `{fc}`>0 AND `{fc}` NOT IN (SELECT `{pc}` FROM `{pt}`)")
        n = c.fetchone()[0]
        status = "OK" if n == 0 else f"FAIL({n})"
        if n > 0:
            all_ok = False
        print(f"    {ft}.{fc} -> {pt}.{pc}: {status}", flush=True)

    print(f"\n  {'✅ ALL CLEAN' if all_ok else '❌ HAS ISSUES'}", flush=True)
    c.close()
    if owns_conn:
        conn.close()


def run_merge(target, sources, conn=None, dry_run=False, host=None, port=None, user=None, password=None):
    print(f"Target: {target}", flush=True)
    print(f"Sources ({len(sources)}): {', '.join(sources)}", flush=True)

    owns_conn = False
    if conn is None:
        conn = get_db_connection(db=target, host=host, port=port, user=user, password=password)
        owns_conn = True

    # Discover tables from first source
    print("\nDiscovering tables to merge...", flush=True)
    tables = discover_merge_tables(sources[0], conn=conn, host=host, port=port, user=user, password=password)

    if dry_run:
        print("\n=== DRY RUN ===\n", flush=True)
        for src in sources:
            merge_tables(conn, src, target, tables, dry_run=True)
        if owns_conn:
            conn.close()
        return

    c = conn.cursor()
    c.execute("SET FOREIGN_KEY_CHECKS = 0")

    total_rows = 0
    all_errors = []
    for src in sources:
        print(f"\n─ Merging {src} ─", flush=True)
        rows, errors = merge_tables(conn, src, target, tables)
        total_rows += rows
        all_errors.extend(errors)
        conn.commit()

    c.execute("SET FOREIGN_KEY_CHECKS = 1")
    c.close()

    if all_errors:
        print(f"\n{len(all_errors)} errors:", flush=True)
        for e in all_errors[:10]:
            print(e, flush=True)

    print(f"\nTotal rows merged: {total_rows:,}", flush=True)

    # Verify
    print("\n=== Verification ===", flush=True)
    verify(target, conn=conn)

    if owns_conn:
        conn.close()
    print("\n[OK] Clinic merge completed.", flush=True)


def main():
    parser = argparse.ArgumentParser(description="Merge multiple clinic temp DBs into one target")
    parser.add_argument("--target", required=True, help="Target database (e.g., heliantmp_merged)")
    parser.add_argument("--sources", required=True, help="Comma-separated source DBs (e.g., heliantmp_1,heliantmp_2)")
    parser.add_argument("--host", default=HOST, help=f"Database host (default: {HOST})")
    parser.add_argument("--port", type=int, default=PORT, help=f"Database port (default: {PORT})")
    parser.add_argument("--user", default=USER, help=f"Database user (default: {USER})")
    parser.add_argument("--password", default=None, help="Database password (defaults to MYSQL_PWD)")
    parser.add_argument("--dry-run", action="store_true", help="Preview without changes")
    args = parser.parse_args()

    sources = [s.strip() for s in args.sources.split(",") if s.strip()]
    run_merge(args.target, sources, dry_run=args.dry_run, host=args.host, port=args.port, user=args.user, password=args.password)


if __name__ == "__main__":
    main()

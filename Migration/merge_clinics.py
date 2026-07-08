"""
Merge multiple temp clinic DBs into a target database.
Auto-discovers which tables to merge (ClinicNum tables + PatNum shared tables).

Usage:
  python merge_clinics.py --target heliantmp_merged --sources heliantmp_1,heliantmp_2,heliantmp_3
  python merge_clinics.py --target helianz --sources helianz_jogja_import,helianz_byl_import --dry-run
"""
import mysql.connector
import argparse
import sys

HOST = "localhost"
USER = "root"
PASSWORD = "J0k0m4r0k3@"


def discover_merge_tables(db):
    """Return ALL tables from the source DB.
    We merge everything using INSERT IGNORE — truly shared tables (definitions, 
    procedure codes, etc.) have non-offset PKs and will be skipped on duplicate key.
    Clinic-specific and clinic-adjacent tables have offset PKs and will insert cleanly."""
    conn = mysql.connector.connect(host=HOST, user=USER, password=PASSWORD, database=db)
    c = conn.cursor()
    c.execute("SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_SCHEMA = %s AND TABLE_TYPE = 'BASE TABLE' ORDER BY TABLE_NAME", (db,))
    tables = [row[0] for row in c.fetchall()]
    c.close()
    conn.close()
    print(f"  Merging all {len(tables)} tables")
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


def verify(target_db):
    """Quick integrity check on the merged DB."""
    conn = mysql.connector.connect(host=HOST, user=USER, password=PASSWORD, database=target_db)
    c = conn.cursor(buffered=True)

    c.execute("SELECT ClinicNum, COUNT(*) FROM patient GROUP BY ClinicNum ORDER BY ClinicNum")
    clinics = c.fetchall()
    print(f"\n  Patients: {sum(r[1] for r in clinics)} total across {len(clinics)} clinics")
    for r in clinics:
        print(f"    ClinicNum={r[0]}: {r[1]}")

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
        print(f"    {ft}.{fc} -> {pt}.{pc}: {status}")

    print(f"\n  {'✅ ALL CLEAN' if all_ok else '❌ HAS ISSUES'}")
    c.close()
    conn.close()


def main():
    parser = argparse.ArgumentParser(description="Merge multiple clinic temp DBs into one target")
    parser.add_argument("--target", required=True, help="Target database (e.g., heliantmp_merged)")
    parser.add_argument("--sources", required=True, help="Comma-separated source DBs (e.g., heliantmp_1,heliantmp_2)")
    parser.add_argument("--dry-run", action="store_true", help="Preview without changes")
    args = parser.parse_args()

    target = args.target
    sources = [s.strip() for s in args.sources.split(",") if s.strip()]

    print(f"Target: {target}")
    print(f"Sources ({len(sources)}): {', '.join(sources)}")

    # Discover tables from first source
    print("\nDiscovering tables to merge...")
    tables = discover_merge_tables(sources[0])

    if args.dry_run:
        print("\n=== DRY RUN ===\n")
        conn = mysql.connector.connect(host=HOST, user=USER, password=PASSWORD, database=target)
        for src in sources:
            merge_tables(conn, src, target, tables, dry_run=True)
        conn.close()
        return

    conn = mysql.connector.connect(host=HOST, user=USER, password=PASSWORD, database=target)
    c = conn.cursor()
    c.execute("SET FOREIGN_KEY_CHECKS = 0")

    total_rows = 0
    all_errors = []
    for src in sources:
        print(f"\n─ Merging {src} ─")
        rows, errors = merge_tables(conn, src, target, tables)
        total_rows += rows
        all_errors.extend(errors)
        conn.commit()

    c.execute("SET FOREIGN_KEY_CHECKS = 1")
    c.close()
    conn.close()

    if all_errors:
        print(f"\n{len(all_errors)} errors:")
        for e in all_errors[:10]:
            print(e)

    print(f"\nTotal rows merged: {total_rows:,}")

    # Verify
    print("\n=== Verification ===")
    verify(target)


if __name__ == "__main__":
    main()

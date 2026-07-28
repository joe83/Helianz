"""
After merging clinics, set all clinic-table AUTO_INCREMENT values
to start from a safe slot above all historical PK ranges.

Usage:
  python set_autoinc.py --db helianz_klaten --start 20000000
  python set_autoinc.py --db helianz_klaten --start 20000000 --dry-run
"""
import mysql.connector
import argparse
import sys

HOST = "localhost"
USER = "root"
PASSWORD = "J0k0m4r0k3@"

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


def set_auto_increment(db, start_val, dry_run=False):
    conn = mysql.connector.connect(host=HOST, user=USER, password=PASSWORD,
                                   database=db)
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
                print(f"  [DRY] {table_name}.{col_name}: {ai:,} -> {start_val:,}")
            else:
                c2 = conn.cursor()
                c2.execute(f"ALTER TABLE `{table_name}` AUTO_INCREMENT = {start_val}")
                c2.close()
            updated += 1
        except Exception as e:
            print(f"  ERROR {table_name}.{col_name}: {e}", file=sys.stderr)

    conn.commit()
    c.close()
    conn.close()

    print(f"\nUpdated: {updated} tables")
    print(f"Skipped (shared PKs): {skipped_shared}")
    print(f"Skipped (already >= {start_val:,}): {skipped_below}")
    
    if dry_run:
        print("⚠️  DRY RUN — no changes made")


def main():
    parser = argparse.ArgumentParser(
        description="Set AUTO_INCREMENT to safe slot above all historical PKs")
    parser.add_argument("--db", required=True, help="Target database")
    parser.add_argument("--start", type=int, required=True,
                        help="Start auto_increment from this value (e.g., 20000000)")
    parser.add_argument("--dry-run", action="store_true", help="Preview only")
    args = parser.parse_args()

    print(f"Database: {args.db}")
    print(f"New auto_increment start: {args.start:,}")
    print()

    set_auto_increment(args.db, args.start, args.dry_run)


if __name__ == "__main__":
    main()

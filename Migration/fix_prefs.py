"""
Fix duplicate preferences after multi-clinic merge.
Preferences use PrefName as the logical key (no DB UNIQUE constraint),
so INSERT IGNORE on PrefNum doesn't prevent duplicates.

Strategy: keep the lowest PrefNum for each PrefName, delete the rest.
"""
import mysql.connector
import sys

HOST = "localhost"
USER = "root"
PASSWORD = "J0k0m4r0k3@"
DB = "helianz"  # The merged production database


def fix_duplicate_prefs(db, dry_run=True):
    conn = mysql.connector.connect(host=HOST, user=USER, password=PASSWORD, database=db)
    c = conn.cursor(buffered=True)

    # Find duplicates
    c.execute("""
        SELECT PrefName, COUNT(*) as cnt, MIN(PrefNum) as keep_num,
               GROUP_CONCAT(PrefNum ORDER BY PrefNum) as all_nums
        FROM preference
        GROUP BY PrefName
        HAVING cnt > 1
        ORDER BY PrefName
    """)
    
    duplicates = c.fetchall()
    
    if not duplicates:
        print(f"[{db}] No duplicate preferences found.")
        c.close()
        conn.close()
        return

    print(f"[{db}] Found {len(duplicates)} duplicate preference names:")
    print(f"  {'PrefName':<40} {'Keep':>8} {'Delete':>12}")
    print(f"  {'-'*40} {'-'*8} {'-'*12}")

    total_deleted = 0
    for pref_name, cnt, keep_num, all_nums in duplicates:
        # Parse the numbers to delete
        nums = [int(n) for n in all_nums.split(',')]
        to_delete = [n for n in nums if n != keep_num]
        
        print(f"  {pref_name:<40} {keep_num:>8} {len(to_delete):>8} rows")
        
        if not dry_run:
            for num in to_delete:
                c2 = conn.cursor()
                c2.execute("DELETE FROM preference WHERE PrefNum = %s", (num,))
                c2.close()
            total_deleted += len(to_delete)

    if not dry_run:
        conn.commit()
        print(f"\nDeleted {total_deleted} duplicate rows.")
    else:
        print(f"\n⚠️  DRY RUN — would delete {total_deleted} rows.")
        print("    Run with --fix to apply changes.")

    c.close()
    conn.close()


if __name__ == "__main__":
    dry_run = "--fix" not in sys.argv
    fix_duplicate_prefs(DB, dry_run=dry_run)

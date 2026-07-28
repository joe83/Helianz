"""
Auto-archive securitylog rows older than 2 years.
Schedule via Windows Task Scheduler or cron.

Usage:
  python archive_securitylog.py
  python archive_securitylog.py --dry-run
  python archive_securitylog.py --db helianz_klaten
  python archive_securitylog.py --years 3
"""
import mysql.connector
import argparse
import sys
from datetime import datetime

HOST = "localhost"
USER = "root"
PASSWORD = "J0k0m4r0k3@"
DEFAULT_DB = "helianz_klaten"

TARGET_DBS = ["helianz_klaten", "helianz_boyolali"]  # All clinic DBs


def archive_securitylog(db, years=2, dry_run=False):
    conn = mysql.connector.connect(host=HOST, user=USER, password=PASSWORD, database=db)
    c = conn.cursor()

    # 1. Ensure archive table exists
    c.execute("CREATE TABLE IF NOT EXISTS securitylog_archive LIKE securitylog")
    c.execute("ALTER TABLE securitylog_archive MODIFY SecurityLogNum bigint(20) NOT NULL")

    # 2. Count rows to archive
    c.execute("""
        SELECT COUNT(*) FROM securitylog
        WHERE LogDateTime < DATE_SUB(NOW(), INTERVAL %s YEAR)
    """, (years,))
    to_archive = c.fetchone()[0]

    if to_archive == 0:
        print(f"[{db}] Nothing to archive (no rows older than {years} years)")
        c.close()
        conn.close()
        return

    print(f"[{db}] Found {to_archive:,} rows older than {years} years")

    if dry_run:
        c.execute("""
            SELECT MIN(LogDateTime), MAX(LogDateTime) FROM securitylog
            WHERE LogDateTime < DATE_SUB(NOW(), INTERVAL %s YEAR)
        """, (years,))
        r = c.fetchone()
        print(f"  Date range: {r[0]} → {r[1]} (DRY RUN - no changes)")
        c.close()
        conn.close()
        return

    # 3. Copy to archive
    c.execute("""
        INSERT IGNORE INTO securitylog_archive
        SELECT * FROM securitylog
        WHERE LogDateTime < DATE_SUB(NOW(), INTERVAL %s YEAR)
    """, (years,))
    copied = c.rowcount
    print(f"  Archived: {copied:,} rows")

    # 4. Delete from active
    c.execute("""
        DELETE FROM securitylog
        WHERE LogDateTime < DATE_SUB(NOW(), INTERVAL %s YEAR)
    """, (years,))
    deleted = c.rowcount
    print(f"  Deleted: {deleted:,} rows")

    # 5. Check remaining
    c.execute("SELECT COUNT(*) FROM securitylog")
    remaining = c.fetchone()[0]
    c.execute("SELECT COUNT(*) FROM securitylog_archive")
    total_archive = c.fetchone()[0]
    print(f"  Active: {remaining:,} rows  |  Archive: {total_archive:,} rows")

    conn.commit()
    c.close()
    conn.close()


def main():
    parser = argparse.ArgumentParser(description="Archive old securitylog rows")
    parser.add_argument("--db", help="Single database to process (default: all clinic DBs)")
    parser.add_argument("--years", type=int, default=2, help="Archive rows older than N years (default: 2)")
    parser.add_argument("--dry-run", action="store_true", help="Preview only, no changes")
    args = parser.parse_args()

    dbs = [args.db] if args.db else TARGET_DBS

    print(f"SecurityLog Archive — {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    if args.dry_run:
        print("⚠️  DRY RUN MODE\n")

    for db in dbs:
        try:
            archive_securitylog(db, args.years, args.dry_run)
        except Exception as e:
            print(f"[{db}] ERROR: {e}", file=sys.stderr)

    print("\nDone.")


if __name__ == "__main__":
    main()

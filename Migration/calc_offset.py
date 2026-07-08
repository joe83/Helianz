"""
Calculate safe offset values for merging clinics.
Queries the target DB for max PK values and suggests offsets that avoid collisions.

Usage:
  python calc_offset.py --target helianz --count 3
  python calc_offset.py --target helianz --count 2 --gap 100000
"""
import mysql.connector
import argparse

HOST = "localhost"
USER = "root"
PASSWORD = "J0k0m4r0k3@"
DEFAULT_GAP = 1_000_000  # Safety gap between clinic PK ranges


def get_max_pks(db):
    """Get max value for every auto_increment PK in the database."""
    conn = mysql.connector.connect(host=HOST, user=USER, password=PASSWORD, database=db)
    c = conn.cursor()

    c.execute("""
        SELECT TABLE_NAME, COLUMN_NAME FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = %s AND EXTRA LIKE '%auto_increment%'
        AND DATA_TYPE = 'bigint'
        ORDER BY TABLE_NAME
    """, (db,))
    pks = c.fetchall()

    max_vals = {}
    for table_name, col_name in pks:
        try:
            c.execute(f"SELECT MAX(`{col_name}`) FROM `{table_name}`")
            row = c.fetchone()
            max_vals[col_name] = row[0] if row[0] else 0
        except Exception:
            pass

    c.close()
    conn.close()
    return max_vals


def main():
    parser = argparse.ArgumentParser(description="Calculate safe PK offsets for clinic merge")
    parser.add_argument("--target", required=True, help="Target database (e.g., helianz)")
    parser.add_argument("--count", type=int, required=True, help="Number of clinics to merge")
    parser.add_argument("--gap", type=int, default=DEFAULT_GAP, help="Safety gap between ranges")
    args = parser.parse_args()

    target = args.target
    count = args.count
    gap = args.gap

    max_pks = get_max_pks(target)

    # Find the absolute maximum PK in target
    overall_max = max(max_pks.values()) if max_pks else 0
    print(f"Target DB: {target}")
    print(f"Max PK value: {overall_max:,}")
    print(f"Safety gap: +{gap:,}")
    print()

    # Calculate offsets
    offsets = {}
    base = overall_max + gap
    for n in range(2, count + 1):
        offset = (n - 1) * base
        offsets[n] = offset
        print(f"  Clinic {n}: offset = +{offset:,} (range: {offset:,} → {offset + overall_max:,})")

    print()
    print("Usage in simulate_merge.py:")
    print(f"  --offset-gap {base}")

    # Show the high-PK tables that might cause overlap
    print(f"\nTop 10 largest PK values:")
    sorted_pks = sorted(max_pks.items(), key=lambda x: x[1], reverse=True)
    for col_name, max_val in sorted_pks[:10]:
        if max_val > gap // 2:
            flag = " ⚠️ LARGE" if max_val > gap else ""
            print(f"  {col_name}: {max_val:,}{flag}")

    if overall_max >= gap:
        print(f"\n⚠️  WARNING: Max PK ({overall_max:,}) exceeds default gap ({gap:,})!")
        print(f"    Old: offset +2M → collision at {2*gap} vs max {overall_max}")
        print(f"    New: offset +{base:,} → safe (no collision)")


if __name__ == "__main__":
    main()

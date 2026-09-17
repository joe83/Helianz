"""
Calculate a safe offset for merging one source DB into a target DB.
Reads max PK values from BOTH databases to ensure no collisions.

Usage:
  python calc_offset.py --target helianz --source helianz_import_jogja
  python calc_offset.py --target helianz --source helianz_import_jogja --gap 100000

Legacy (simulation mode — estimates offsets for N identical copies):
  python calc_offset.py --target helianz --count 3
"""
import os
import mysql.connector
import argparse

HOST = os.environ.get("MYSQL_HOST", "localhost")
PORT = int(os.environ.get("MYSQL_TCP_PORT", "3306"))
USER = os.environ.get("MYSQL_USER", "root")
PASSWORD = os.environ.get("MYSQL_PWD", "J0k0m4r0k3@")
DEFAULT_GAP = 1_000_000  # Safety gap above max PK


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


def get_max_pks(db, conn=None):
    """Get max value for every auto_increment PK in the database.
    Returns dict: {column_name: (max_value, table_name)}"""
    owns_conn = False
    if conn is None:
        conn = get_db_connection(db=db)
        owns_conn = True
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
            val = row[0] if row[0] else 0
            # Keep the highest value if multiple tables share a PK column name
            if col_name not in max_vals or val > max_vals[col_name][0]:
                max_vals[col_name] = (val, table_name)
        except Exception:
            pass

    c.close()
    if owns_conn:
        conn.close()
    return max_vals


def main():
    parser = argparse.ArgumentParser(description="Calculate safe PK offset for clinic merge")
    parser.add_argument("--target", required=True, help="Target database (e.g., helianz)")
    parser.add_argument("--source", default=None, help="Source database to merge in (e.g., helianz_import_jogja)")
    parser.add_argument("--gap", type=int, default=DEFAULT_GAP, help="Safety gap above max PK (default: 1000000)")
    # Legacy simulation mode
    parser.add_argument("--count", type=int, default=None, help="(Legacy) Number of clinics — estimates offsets assuming identical copies")
    args = parser.parse_args()

    if not args.source and not args.count:
        parser.error("Either --source or --count is required")

    target = args.target
    gap = args.gap

    target_pks = get_max_pks(target)
    target_max = max(v[0] for v in target_pks.values()) if target_pks else 0

    if args.source:
        # ── Real mode: compare target and source ──
        source = args.source
        source_pks = get_max_pks(source)
        source_max = max(v[0] for v in source_pks.values()) if source_pks else 0

        # The offset must be > max(target_max, source_max) so that
        # source PKs after offset don't collide with target PKs
        needed = max(target_max, source_max)
        safe_offset = needed + gap

        print(f"Target DB:  {target}  (max PK = {target_max:,})")
        print(f"Source DB:  {source}  (max PK = {source_max:,})")
        print(f"Safety gap: +{gap:,}")
        print()
        print(f"  Safe offset = {safe_offset:,}")
        print()
        print(f"Usage:")
        print(f"  python offset_db.py {safe_offset} --db {source}")

        # Show per-column breakdown where source > target (potential collisions)
        collisions = []
        for col_name, (src_val, src_tbl) in source_pks.items():
            tgt_val = target_pks.get(col_name, (0, ""))[0]
            if src_val > 0 and tgt_val > 0:
                collisions.append((col_name, tgt_val, src_val, src_tbl))

        if collisions:
            print(f"\nPer-column max PKs (target vs source):")
            collisions.sort(key=lambda x: max(x[1], x[2]), reverse=True)
            for col_name, tgt_val, src_val, src_tbl in collisions[:15]:
                flag = " ⚠️ OVERLAP" if src_val >= safe_offset else ""
                print(f"  {col_name}: target={tgt_val:,}  source={src_val:,}{flag}")

    else:
        # ── Legacy simulation mode ──
        count = args.count
        overall_max = target_max

        print(f"Target DB: {target}")
        print(f"Max PK value: {overall_max:,}")
        print(f"Safety gap: +{gap:,}")
        print(f"⚠️  Simulation mode: assumes all {count} clinics have similar data size")
        print()

        base = overall_max + gap
        for n in range(2, count + 1):
            offset = (n - 1) * base
            print(f"  Clinic {n}: offset = +{offset:,} (range: {offset:,} → {offset + overall_max:,})")

        print()
        print("Usage in simulate_merge.py:")
        print(f"  --offset-gap {base}")

        # Show the high-PK tables that might cause overlap
        print(f"\nTop 10 largest PK values:")
        sorted_pks = sorted(target_pks.items(), key=lambda x: x[1][0], reverse=True)
        for col_name, (max_val, tbl_name) in sorted_pks[:10]:
            if max_val > gap // 2:
                flag = " ⚠️ LARGE" if max_val > gap else ""
                print(f"  {col_name} ({tbl_name}): {max_val:,}{flag}")

        if overall_max >= gap:
            print(f"\n⚠️  WARNING: Max PK ({overall_max:,}) exceeds default gap ({gap:,})!")
            print(f"    Old: offset +2M → collision at {2*gap} vs max {overall_max}")
            print(f"    New: offset +{base:,} → safe (no collision)")


if __name__ == "__main__":
    main()

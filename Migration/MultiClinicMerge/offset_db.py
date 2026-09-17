"""
Offset clinic-specific PKs and FKs by +OFFSET.
Parses FK mappings from C# TableTypes to catch non-matching column names
(e.g., appointment.Op -> operatory.OperatoryNum).

Usage:
  python offset_db.py 2000000 --db helianz_jogja_import
  python offset_db.py 3000000 --db helianz_byl_import --dry-run
"""
import mysql.connector
import argparse
import re
import os
import glob
import json

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


def find_repo_root(start_dir):
    cur = os.path.abspath(start_dir)
    while True:
        if os.path.exists(os.path.join(cur, "HelianzBusiness")) or os.path.exists(os.path.join(cur, "Helianz.sln")):
            return cur
        parent = os.path.dirname(cur)
        if parent == cur:
            break
        cur = parent
    return os.path.dirname(os.path.dirname(os.path.abspath(start_dir)))

REPO_ROOT = find_repo_root(os.path.dirname(os.path.abspath(__file__)))
TABLETYPES_DIR = os.path.join(REPO_ROOT, "HelianzBusiness", "TableTypes")


# C# class name → DB table name mappings (OpenDental uses different names)
CS_TO_DB_TABLE = {
    'procedure': 'procedurelog',
    'appointmenttype': 'appointmenttype',
    'claimform': 'claimform',
    'sheetdef': 'sheetdef',
    'sheetfielddef': 'sheetfielddef',
    'emailtemplate': 'emailtemplate',
    'emailmessage': 'emailmessage',
    'emailaddress': 'emailaddress',
    'statement': 'statement',
    'transactioninvoice': 'transactioninvoice',
}


def discover_fk_map():
    """Load FK mappings from bundled fk_map.json or parse C# TableTypes.
    Returns dict: (source_table, source_column) -> (target_table, target_column)"""
    # 1. Bundled JSON cache in script directory
    script_dir = os.path.dirname(os.path.abspath(__file__))
    json_path = os.path.join(script_dir, "fk_map.json")
    if os.path.exists(json_path):
        try:
            with open(json_path, "r", encoding="utf-8") as f:
                data = json.load(f)
            fk_map = {}
            for k, v in data.items():
                st, sc = k.split(".", 1)
                tt, tc = v.split(".", 1)
                fk_map[(st, sc)] = (tt, tc)
            return fk_map
        except Exception:
            pass

    # 2. Parse C# TableTypes if directory exists
    pattern = re.compile(r'///<summary>FK to (\w+)\.(\w+)')
    fk_map = {}

    if os.path.exists(TABLETYPES_DIR):
        for cs_file in glob.glob(os.path.join(TABLETYPES_DIR, '*.cs')):
            source_table = os.path.splitext(os.path.basename(cs_file))[0].lower()
            with open(cs_file, encoding='utf-8', errors='ignore') as f:
                lines = f.readlines()
            for i, line in enumerate(lines):
                m = pattern.search(line)
                if m:
                    target_table, target_col = m.group(1).lower(), m.group(2).lower()
                    target_table = CS_TO_DB_TABLE.get(target_table, target_table)
                    source_table = CS_TO_DB_TABLE.get(source_table, source_table)
                    for j in range(i + 1, min(i + 5, len(lines))):
                        prop = re.search(r'public \w+ (\w+)', lines[j])
                        if prop:
                            source_col = prop.group(1).lower()
                            fk_map[(source_table, source_col)] = (target_table, target_col)
                            break
    return fk_map


def run(offset, db, dry_run=False, conn=None, host=None, port=None, user=None, password=None):
    print(f"Offset: +{offset:,}  |  Database: {db}", flush=True)
    if dry_run:
        print("⚠️  DRY RUN\n", flush=True)

    # ── Discover FK map from source ──
    fk_map = discover_fk_map()
    print(f"FK mappings loaded: {len(fk_map)}", flush=True)

    owns_conn = False
    if conn is None:
        conn = get_db_connection(db=db, host=host, port=port, user=user, password=password)
        owns_conn = True

    cursor = conn.cursor()
    if not dry_run:
        cursor.execute("SET FOREIGN_KEY_CHECKS = 0")

    # ── Classify tables ──
    cursor.execute("""
        SELECT DISTINCT TABLE_NAME FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = %s AND COLUMN_NAME = 'ClinicNum'
    """, (db,))
    clinic_tables = {row[0] for row in cursor.fetchall()}

    # Also include tables with PatNum but no ClinicNum (patient-specific shared tables)
    # These contain per-patient data (documents, recalls, commlog, etc.) and need PK offset
    cursor.execute("""
        SELECT DISTINCT c1.TABLE_NAME FROM information_schema.COLUMNS c1
        JOIN information_schema.COLUMNS c1pk ON c1pk.TABLE_SCHEMA=c1.TABLE_SCHEMA 
            AND c1pk.TABLE_NAME=c1.TABLE_NAME AND c1pk.EXTRA LIKE '%auto_increment%'
        WHERE c1.TABLE_SCHEMA = %s AND c1.COLUMN_NAME = 'PatNum'
        AND c1.TABLE_NAME NOT IN (
            SELECT DISTINCT c2.TABLE_NAME FROM information_schema.COLUMNS c2
            WHERE c2.TABLE_SCHEMA = %s AND c2.COLUMN_NAME = 'ClinicNum'
        )
    """, (db, db))
    patient_shared_tables = {row[0] for row in cursor.fetchall()}

    # Category 3: Clinic-adjacent tables (no ClinicNum/PatNum, but have FKs to clinic tables)
    cursor.execute("""
        SELECT DISTINCT c3.TABLE_NAME FROM information_schema.COLUMNS c3
        JOIN information_schema.COLUMNS c3pk ON c3pk.TABLE_SCHEMA=c3.TABLE_SCHEMA
            AND c3pk.TABLE_NAME=c3.TABLE_NAME AND c3pk.EXTRA LIKE '%auto_increment%'
        WHERE c3.TABLE_SCHEMA = %s
        AND c3.COLUMN_NAME IN (
            SELECT DISTINCT c_pk.COLUMN_NAME FROM information_schema.COLUMNS c_pk
            WHERE c_pk.TABLE_SCHEMA = %s AND c_pk.EXTRA LIKE '%auto_increment%'
            AND c_pk.TABLE_NAME IN (
                SELECT DISTINCT TABLE_NAME FROM information_schema.COLUMNS
                WHERE TABLE_SCHEMA = %s AND COLUMN_NAME = 'ClinicNum'
            )
        )
        AND c3.TABLE_NAME NOT IN (
            SELECT DISTINCT TABLE_NAME FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = %s AND (COLUMN_NAME = 'ClinicNum' OR COLUMN_NAME = 'PatNum')
        )
    """, (db, db, db, db))
    clinic_adjacent_tables = {row[0] for row in cursor.fetchall()}
    clinic_tables |= patient_shared_tables | clinic_adjacent_tables

    cursor.execute("""
        SELECT TABLE_NAME, COLUMN_NAME FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = %s AND EXTRA LIKE '%auto_increment%'
    """, (db,))
    all_pks = {row[0]: row[1] for row in cursor.fetchall()}

    shared_tables = set(all_pks.keys()) - clinic_tables

    # PK name is "shared" only if NO clinic-specific table uses it as PK
    # Normalize to lowercase for case-insensitive comparison
    clinic_pk_names = {all_pks[t].lower() for t in clinic_tables}
    shared_pk_names = {all_pks[t].lower() for t in shared_tables} - clinic_pk_names
    shared_pk_names.add('clinicnum')

    # ── Classify PKs ──
    pk_offset = []
    for table_name, pk_col in all_pks.items():
        if pk_col.lower() not in shared_pk_names and table_name not in shared_tables:
            pk_offset.append((table_name, pk_col))

    # ── Classify FKs (2 methods: name match + source code FK map) ──
    fk_offset = set()

    # Method 1: Auto-detect by column name matching PK names
    cursor.execute("""
        SELECT TABLE_NAME, COLUMN_NAME FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = %s AND COLUMN_NAME IN (
            SELECT COLUMN_NAME FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = %s AND EXTRA LIKE '%auto_increment%'
        ) AND DATA_TYPE = 'bigint'
        ORDER BY TABLE_NAME, COLUMN_NAME
    """, (db, db))
    for table_name, col_name in cursor.fetchall():
        if table_name in all_pks and all_pks[table_name].lower() == col_name.lower():
            continue
        if col_name.lower() not in shared_pk_names:
            fk_offset.add((table_name, col_name))

    # Method 2: Source-code FK map for non-matching column names
    extra_fks = 0
    for (src_tbl, src_col), (tgt_tbl, tgt_col) in fk_map.items():
        # Only if target table is clinic-specific AND source column doesn't match target PK name
        # AND the source table actually exists in DB
        if (tgt_tbl in clinic_tables and src_col.lower() != tgt_col.lower()
                and src_tbl in all_pks):
            fk_offset.add((src_tbl, src_col))
            extra_fks += 1

    fk_offset = sorted(fk_offset)

    print(f"Clinic-specific tables: {len(clinic_tables)}")
    print(f"Shared tables: {len(shared_tables)}")
    print(f"PKs to offset: {len(pk_offset)}")
    print(f"FKs to offset: {len(fk_offset)} (including {extra_fks} from source-code FK map)")

    if extra_fks > 0:
        print("\n  Source-code FK mappings added:")
        for (st, sc), (tt, tc) in sorted(fk_map.items()):
            if tt in clinic_tables and sc.lower() != tc.lower():
                print(f"    {st}.{sc} -> {tt}.{tc}")

    if dry_run:
        print("\n=== DRY RUN (sample) ===")
        for table, col in pk_offset[:5]:
            print(f"  UPDATE {table} SET {col} = {col} + {offset}")
        for table, col in fk_offset[:10]:
            print(f"  UPDATE {table} SET {col} = {col} + {offset}")
        cursor.close()
        conn.close()
        return

    # ── Execute ──
    errors = []
    print("\n=== Phase A: Offset clinic-specific PKs ===")
    for table_name, col_name in pk_offset:
        try:
            sql = f"UPDATE `{table_name}` SET `{col_name}` = `{col_name}` + {offset} WHERE `{col_name}` > 0 ORDER BY `{col_name}` DESC"
            cursor.execute(sql)
        except Exception as e:
            errors.append((table_name, col_name, str(e)))

    print("=== Phase B: Offset clinic-specific FKs ===")
    for table_name, col_name in fk_offset:
        try:
            sql = f"UPDATE `{table_name}` SET `{col_name}` = `{col_name}` + {offset} WHERE `{col_name}` > 0"
            cursor.execute(sql)
        except Exception as e:
            errors.append((table_name, col_name, str(e)))

    print("=== Phase C: Reset auto_increment ===")
    for table_name in clinic_tables:
        if table_name in all_pks and all_pks[table_name] not in shared_pk_names:
            try:
                cursor.execute(f"ALTER TABLE `{table_name}` AUTO_INCREMENT = {offset + 1}")
            except Exception as e:
                pass

    conn.commit()

    if errors:
        print(f"\n{len(errors)} errors:")
        for t, c, e in errors[:10]:
            print(f"  {t}.{c}: {e}")
    else:
        print("\n✅ All offsets applied!")

    # ── Verify ──
    cursor2 = conn.cursor(buffered=True)

    print("\n=== Clinic identities ===")
    cursor2.execute("SELECT ClinicNum, Description FROM clinic ORDER BY ClinicNum")
    for row in cursor2.fetchall():
        print(f"  ClinicNum={row[0]} {row[1]}")

    print("\n=== Key tables ===")
    for table in ['patient', 'procedurelog', 'appointment', 'payment', 'operatory']:
        pk = all_pks.get(table)
        if pk:
            cursor2.execute(f"SELECT MIN(`{pk}`) as mn, MAX(`{pk}`) as mx FROM `{table}`")
            r = cursor2.fetchone()
            print(f"  {table}.{pk}: {r[0]} → {r[1]}")

    print("\n=== Referential integrity ===")
    checks = [
        ('procedurelog', 'patnum', 'patient', 'patnum'),
        ('appointment', 'patnum', 'patient', 'patnum'),
        ('appointment', 'op', 'operatory', 'operatorynum'),
        ('paysplit', 'patnum', 'patient', 'patnum'),
        ('payment', 'patnum', 'patient', 'patnum'),
        ('adjustment', 'patnum', 'patient', 'patnum'),
    ]
    for fk_t, fk_c, pk_t, pk_c in checks:
        cursor2.execute(f"SELECT COUNT(*) FROM `{fk_t}` WHERE `{fk_c}` > 0 AND `{fk_c}` NOT IN (SELECT `{pk_c}` FROM `{pk_t}`)")
        cnt = cursor2.fetchone()[0]
        status = "✅" if cnt == 0 else f"❌ {cnt} ORPHANS!"
        print(f"  {fk_t}.{fk_c} -> {pk_t}.{pk_c}: {status}")

    cursor2.close()
    cursor.close()
    if owns_conn:
        conn.close()
    print("\n[OK] Offset complete.", flush=True)


run_offset = run


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Offset clinic-specific PKs/FKs by N to avoid ID collisions when merging")
    parser.add_argument("offset", type=int, help="Offset amount (e.g., 2000000)")
    parser.add_argument("--db", default="heliantmp", help="Database name")
    parser.add_argument("--host", default=HOST, help=f"Database host (default: {HOST})")
    parser.add_argument("--port", type=int, default=PORT, help=f"Database port (default: {PORT})")
    parser.add_argument("--user", default=USER, help=f"Database user (default: {USER})")
    parser.add_argument("--password", default=None, help="Database password (defaults to MYSQL_PWD)")
    parser.add_argument("--dry-run", action="store_true", help="Preview only")
    args = parser.parse_args()
    run(args.offset, args.db, args.dry_run, host=args.host, port=args.port, user=args.user, password=args.password)

"""
Harmonize Shared Catalogs across Clinic Databases
==================================================
Handles unification and remapping of:
  1. procedurecode (ProcCode string matching -> target CodeNum)
  2. definition (Category + ItemName matching -> target DefNum)

Used prior to table merge to prevent catalog collisions and foreign key corruption.
"""

import sys

# Tables and columns that reference procedurecode.CodeNum
CODE_NUM_REFS = [
    ("procedurelog", "CodeNum"),
    ("fee", "CodeNum"),
    ("autocodeitem", "CodeNum"),
    ("procbuttonitem", "CodeNum"),
    ("proccodenote", "CodeNum"),
    ("recalltrigger", "CodeNum"),
    ("benefit", "CodeNum"),
    ("substitutionlink", "CodeNum"),
    ("toothgridcol", "CodeNum"),
    ("toothgriddef", "CodeNum"),
    ("reqstudent", "CodeNum"),
]

# Tables and columns that reference definition.DefNum
DEF_NUM_REFS = [
    ("payment", "PayType"),
    ("adjustment", "AdjType"),
    ("document", "DocCategory"),
    ("patient", "BillingType"),
    ("appointment", "Confirmed"),
    ("appointment", "UnschedStatus"),
    ("recall", "RecallStatus"),
    ("claimpayment", "PayType"),
    ("claimpayment", "PayGroup"),
    ("claimtracking", "TrackingDefNum"),
    ("claimtracking", "TrackingErrorDefNum"),
    ("claimproc", "ClaimPaymentTracking"),
    ("commlog", "CommType"),
    ("paysplit", "UnearnedType"),
    ("operatory", "OperatoryType"),
    ("procedurecode", "ProcCat"),
    ("procedurelog", "Dx"),
    ("procedurelog", "Priority"),
    ("procedurelog", "BillingTypeOne"),
    ("procedurelog", "BillingTypeTwo"),
    ("procedurelog", "Prognosis"),
    ("proctp", "Priority"),
    ("provider", "Specialty"),
    ("schedule", "BlockoutType"),
    ("task", "PriorityDefNum"),
    ("task", "TriageCategory"),
    ("treatplanattach", "Priority"),
    ("insplan", "BillingType"),
    ("mount", "DocCategory"),
    ("mountdef", "DefaultCat"),
    ("lettermerge", "Category"),
    ("carrier", "CarrierGroupName"),
    ("deposit", "DepositAccountNum"),
    ("creditcard", "PaymentType"),
    ("cert", "CertCategoryNum"),
    ("contact", "Category"),
    ("autonote", "Category"),
    ("sheetdef", "AutoCheckSaveImageDocCategory"),
    ("midtransconfig", "PayTypeDefNum"),
]


def harmonize_procedurecodes(conn, src_db, target_db):
    """
    Ensures all procedure codes from src_db exist in target_db (matching by ProcCode).
    Remaps all foreign keys in src_db that point to CodeNum so they point to target_db's CodeNum.
    """
    cursor = conn.cursor(dictionary=True)
    print(f"\n  [PROCEDURECODE] Harmonizing `{src_db}` -> `{target_db}`...")

    # 1. Load target procedure codes:
    # Key 1: (code.upper(), descript.lower()) -> CodeNum
    # Key 2: code.upper() -> CodeNum
    cursor.execute(f"SELECT CodeNum, ProcCode, Descript FROM `{target_db}`.procedurecode")
    target_by_code_desc = {}
    target_by_code = {}
    for r in cursor.fetchall():
        code = (r['ProcCode'] or '').strip().upper()
        desc = (r['Descript'] or '').strip().lower()
        if (code, desc) not in target_by_code_desc:
            target_by_code_desc[(code, desc)] = r['CodeNum']
        if code not in target_by_code:
            target_by_code[code] = r['CodeNum']

    # 2. Inspect source procedure codes
    cursor.execute(f"SELECT * FROM `{src_db}`.procedurecode")
    src_codes = cursor.fetchall()

    # Get column names for insert (excluding CodeNum)
    cursor.execute(f"""
        SELECT COLUMN_NAME FROM information_schema.COLUMNS 
        WHERE TABLE_SCHEMA = '{target_db}' AND TABLE_NAME = 'procedurecode' 
          AND EXTRA NOT LIKE '%auto_increment%'
        ORDER BY ORDINAL_POSITION
    """)
    insert_cols = [r['COLUMN_NAME'] for r in cursor.fetchall()]
    col_str = "`, `".join(insert_cols)
    placeholders = ", ".join(["%s"] * len(insert_cols))

    code_map = {}  # old_CodeNum -> new_CodeNum
    new_inserted = 0

    for r in src_codes:
        old_id = r['CodeNum']
        code_str = (r['ProcCode'] or '').strip().upper()
        desc_str = (r['Descript'] or '').strip().lower()

        # Match preference:
        # 1. Exact match on (ProcCode, Descript)
        # 2. Or if ProcCode exists and description is blank / near match
        if (code_str, desc_str) in target_by_code_desc:
            code_map[old_id] = target_by_code_desc[(code_str, desc_str)]
        elif code_str in target_by_code and not desc_str:
            code_map[old_id] = target_by_code[code_str]
        else:
            # Different procedure description or entirely new code -> insert into target
            vals = [r.get(col) for col in insert_cols]
            cursor.execute(
                f"INSERT INTO `{target_db}`.procedurecode (`{col_str}`) VALUES ({placeholders})",
                vals
            )
            new_id = cursor.lastrowid
            target_by_code_desc[(code_str, desc_str)] = new_id
            if code_str not in target_by_code:
                target_by_code[code_str] = new_id
            code_map[old_id] = new_id
            new_inserted += 1

    conn.commit()
    print(f"    Mapped {len(code_map)} procedure codes (New inserted into target: {new_inserted})")

    # 3. Remap all foreign keys in src_db
    # We do a batch update via CASE or temporary table for maximum speed
    # A temp table is fastest and safest for 500+ items
    cursor.execute(f"CREATE TEMPORARY TABLE IF NOT EXISTS `{src_db}`._tmp_code_map (old_id BIGINT PRIMARY KEY, new_id BIGINT)")
    cursor.execute(f"TRUNCATE TABLE `{src_db}`._tmp_code_map")
    
    # Insert mapping
    map_rows = [(k, v) for k, v in code_map.items() if k != v]
    if map_rows:
        cursor.executemany(f"INSERT INTO `{src_db}`._tmp_code_map (old_id, new_id) VALUES (%s, %s)", map_rows)
        conn.commit()

        # Update child tables
        for tbl, col in CODE_NUM_REFS:
            # Check if table exists in src_db
            cursor.execute(f"""
                SELECT 1 FROM information_schema.COLUMNS 
                WHERE TABLE_SCHEMA = '{src_db}' AND TABLE_NAME = '{tbl}' AND COLUMN_NAME = '{col}'
            """)
            if not cursor.fetchone():
                continue

            update_sql = f"""
                UPDATE `{src_db}`.`{tbl}` t
                JOIN `{src_db}`._tmp_code_map m ON t.`{col}` = m.old_id
                SET t.`{col}` = m.new_id
            """
            cursor.execute(update_sql)
            if cursor.rowcount > 0:
                print(f"    Updated {tbl}.{col}: {cursor.rowcount:,} rows remapped")
        conn.commit()
    else:
        print("    All procedure codes already match target IDs exactly.")

    cursor.execute(f"DROP TEMPORARY TABLE IF EXISTS `{src_db}`._tmp_code_map")
    cursor.close()
    conn.commit()
    print("    [OK] Procedure code harmonization completed.")


def harmonize_definitions(conn, src_db, target_db):
    """
    Ensures all definitions from src_db exist in target_db (matching by Category + ItemName).
    Remaps all foreign keys in src_db that point to DefNum so they point to target_db's DefNum.
    """
    cursor = conn.cursor(dictionary=True)
    print(f"\n  [DEFINITION] Harmonizing `{src_db}` -> `{target_db}`...")

    # 1. Load target definitions: (Category, LOWER(ItemName)) -> DefNum
    cursor.execute(f"SELECT DefNum, Category, ItemName FROM `{target_db}`.definition")
    target_defs = {}
    for r in cursor.fetchall():
        key = (r['Category'], r['ItemName'].strip().lower())
        if key not in target_defs:
            target_defs[key] = r['DefNum']

    # 2. Inspect source definitions
    cursor.execute(f"SELECT * FROM `{src_db}`.definition")
    src_defs = cursor.fetchall()

    cursor.execute(f"""
        SELECT COLUMN_NAME FROM information_schema.COLUMNS 
        WHERE TABLE_SCHEMA = '{target_db}' AND TABLE_NAME = 'definition' 
          AND EXTRA NOT LIKE '%auto_increment%'
        ORDER BY ORDINAL_POSITION
    """)
    insert_cols = [r['COLUMN_NAME'] for r in cursor.fetchall()]
    col_str = "`, `".join(insert_cols)
    placeholders = ", ".join(["%s"] * len(insert_cols))

    def_map = {}  # old_DefNum -> new_DefNum
    new_inserted = 0

    for r in src_defs:
        old_id = r['DefNum']
        key = (r['Category'], r['ItemName'].strip().lower())

        if key in target_defs:
            def_map[old_id] = target_defs[key]
        else:
            # Insert new definition into target
            vals = [r.get(col) for col in insert_cols]
            cursor.execute(
                f"INSERT INTO `{target_db}`.definition (`{col_str}`) VALUES ({placeholders})",
                vals
            )
            new_id = cursor.lastrowid
            target_defs[key] = new_id
            def_map[old_id] = new_id
            new_inserted += 1

    conn.commit()
    print(f"    Mapped {len(def_map)} definitions (New inserted into target: {new_inserted})")

    # 3. Remap all foreign keys in src_db
    cursor.execute(f"CREATE TEMPORARY TABLE IF NOT EXISTS `{src_db}`._tmp_def_map (old_id BIGINT PRIMARY KEY, new_id BIGINT)")
    cursor.execute(f"TRUNCATE TABLE `{src_db}`._tmp_def_map")

    map_rows = [(k, v) for k, v in def_map.items() if k != v]
    if map_rows:
        cursor.executemany(f"INSERT INTO `{src_db}`._tmp_def_map (old_id, new_id) VALUES (%s, %s)", map_rows)
        conn.commit()

        for tbl, col in DEF_NUM_REFS:
            cursor.execute(f"""
                SELECT 1 FROM information_schema.COLUMNS 
                WHERE TABLE_SCHEMA = '{src_db}' AND TABLE_NAME = '{tbl}' AND COLUMN_NAME = '{col}'
            """)
            if not cursor.fetchone():
                continue

            update_sql = f"""
                UPDATE `{src_db}`.`{tbl}` t
                JOIN `{src_db}`._tmp_def_map m ON t.`{col}` = m.old_id
                SET t.`{col}` = m.new_id
            """
            cursor.execute(update_sql)
            if cursor.rowcount > 0:
                print(f"    Updated {tbl}.{col}: {cursor.rowcount:,} rows remapped")
        conn.commit()
    else:
        print("    All definitions already match target IDs exactly.")

    cursor.execute(f"DROP TEMPORARY TABLE IF EXISTS `{src_db}`._tmp_def_map")
    cursor.close()
    conn.commit()
    print("    [OK] Definition harmonization completed.")

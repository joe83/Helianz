"""
Fix procedurelog.Share=0 for June-July 2026 procedures.

BUG: In legacy code, Share was calculated using patient's primary provider's
fee schedule instead of the procedure's actual provider.

USAGE:
  python fix_share_zero_jun_jul2026.py [--apply] [--host HOST] [--user USER] [--password PASS] [--database DB]

  Default: dry-run mode (scans only, no changes)
  --apply : actually write changes to the database
"""
import sys
import traceback

# -- Configuration --------------------------------------------------
DB_HOST = 'localhost'
DB_USER = 'root'
DB_PASS = 'J0k0m4r0k3@'
DB_NAME = 'helianz_klt'
DATE_FROM = '2026-06-01'
DATE_TO   = '2026-07-31'
DRY_RUN = True

# -- Parse CLI args -------------------------------------------------
args = sys.argv[1:]
i = 0
while i < len(args):
    if args[i] == '--apply':
        DRY_RUN = False
    elif args[i] == '--host' and i + 1 < len(args):
        DB_HOST = args[i + 1]; i += 1
    elif args[i] == '--user' and i + 1 < len(args):
        DB_USER = args[i + 1]; i += 1
    elif args[i] == '--password' and i + 1 < len(args):
        DB_PASS = args[i + 1]; i += 1
    elif args[i] == '--database' and i + 1 < len(args):
        DB_NAME = args[i + 1]; i += 1
    elif args[i] in ('-h', '--help'):
        print(__doc__)
        input("Press Enter to exit...")
        sys.exit(0)
    i += 1

MODE = "DRY-RUN (no changes will be written)" if DRY_RUN else "LIVE (WILL write to DB)"


def main():
    import mysql.connector

    print("=" * 72)
    print(f"  Fix Share=0 for June-July 2026")
    print(f"  Mode: {MODE}")
    print(f"  DB:   {DB_HOST}/{DB_NAME}")
    print(f"  User: {DB_USER}")
    print("=" * 72)
    print()

    # -- Connect ----------------------------------------------------
    print("  [1/4] Connecting to database...")
    try:
        conn = mysql.connector.connect(
            host=DB_HOST,
            user=DB_USER,
            password=DB_PASS,
            database=DB_NAME,
            use_pure=True,
        )
    except mysql.connector.errors.InterfaceError as e:
        print(f"  ERROR: Cannot connect to MySQL at {DB_HOST}.")
        print(f"  Details: {e}")
        print(f"  Is MySQL running? Try: mysql -u {DB_USER} -p -h {DB_HOST}")
        return
    except Exception as e:
        print(f"  ERROR connecting: {e}")
        return

    print("  Connected OK.")
    c = conn.cursor(buffered=True, dictionary=True)

    # -- PHASE 1: SCAN ----------------------------------------------
    print()
    print("  [2/4] Scanning for Share=0 procedures...")
    c.execute("""
        SELECT
            pl.ProcNum, pl.PatNum, pl.ProvNum AS ProcProvNum,
            pl.CodeNum, pl.ProcFee, pl.Share, pl.ClinicNum, pl.ProcDate,
            pc.ProcCode, pc.Descript,
            pt.LName AS PatLName, pt.FName AS PatFName, pt.PriProv AS PatPriProv,
            pv.Abbr AS ProvAbbr, pv.FeeSched AS ProvFeeSched
        FROM procedurelog pl
        JOIN procedurecode pc ON pl.CodeNum = pc.CodeNum
        JOIN patient pt ON pl.PatNum = pt.PatNum
        JOIN provider pv ON pl.ProvNum = pv.ProvNum
        WHERE pl.Share = 0
          AND pl.ProcFee > 0
          AND pl.ProcStatus = 2
          AND pl.ProcDate >= %s
          AND pl.ProcDate <= %s
        ORDER BY pl.ProcDate, pl.PatNum
    """, (DATE_FROM, DATE_TO))

    procs = c.fetchall()
    print(f"  Found {len(procs)} completed procedures with Share=0.")

    if not procs:
        print("  Nothing to fix.")
        conn.close()
        return

    # -- PHASE 2: CALCULATE -----------------------------------------
    print()
    print("  [3/4] Calculating correct Share values...")
    fixes = []
    unchanged = 0
    no_fee = []

    for p in procs:
        code_num = p['CodeNum']
        clinic_num = p['ClinicNum']
        prov_num = p['ProcProvNum']
        prov_fs = p['ProvFeeSched']
        pat_name = f"{p['PatFName']} {p['PatLName']}"

        provider_share = None
        matched_via = None
        fs_filter = "AND FeeSched = %s" if prov_fs > 0 else ""

        # 1. Exact
        params = (code_num, prov_fs, clinic_num, prov_num) if prov_fs > 0 else (code_num, clinic_num, prov_num)
        c.execute(f"SELECT ProviderShare FROM fee WHERE CodeNum=%s {fs_filter} AND ClinicNum=%s AND ProvNum=%s LIMIT 1", params)
        row = c.fetchone()
        if row: provider_share = float(row['ProviderShare']); matched_via = 'exact'

        # 2. Provider override
        if provider_share is None and prov_num > 0:
            params = (code_num, prov_fs, prov_num) if prov_fs > 0 else (code_num, prov_num)
            c.execute(f"SELECT ProviderShare FROM fee WHERE CodeNum=%s {fs_filter} AND ClinicNum=0 AND ProvNum=%s LIMIT 1", params)
            row = c.fetchone()
            if row: provider_share = float(row['ProviderShare']); matched_via = 'prov_override'

        # 3. Clinic override
        if provider_share is None and clinic_num > 0:
            params = (code_num, prov_fs, clinic_num) if prov_fs > 0 else (code_num, clinic_num)
            c.execute(f"SELECT ProviderShare FROM fee WHERE CodeNum=%s {fs_filter} AND ClinicNum=%s AND ProvNum=0 LIMIT 1", params)
            row = c.fetchone()
            if row: provider_share = float(row['ProviderShare']); matched_via = 'clinic_override'

        # 4. HQ
        if provider_share is None:
            params = (code_num, prov_fs) if prov_fs > 0 else (code_num,)
            c.execute(f"SELECT ProviderShare FROM fee WHERE CodeNum=%s {fs_filter} AND ClinicNum=0 AND ProvNum=0 LIMIT 1", params)
            row = c.fetchone()
            if row: provider_share = float(row['ProviderShare']); matched_via = 'hq'

        # 5. Any fee schedule
        if provider_share is None:
            c.execute("""
                SELECT f.ProviderShare, fs.Description
                FROM fee f LEFT JOIN feesched fs ON f.FeeSched=fs.FeeSchedNum
                WHERE f.CodeNum=%s AND f.ClinicNum=%s AND f.ProvNum=%s LIMIT 1
            """, (code_num, clinic_num, prov_num))
            row = c.fetchone()
            if row:
                provider_share = float(row['ProviderShare'])
                matched_via = f"any_fs({row['Description']})"

        if provider_share is None:
            no_fee.append(p['ProcNum'])
        elif provider_share == 0.0:
            unchanged += 1
        else:
            fixes.append({
                'ProcNum': p['ProcNum'], 'PatName': pat_name,
                'ProcDate': str(p['ProcDate']), 'ProcCode': p['ProcCode'],
                'Descript': p['Descript'], 'ProvAbbr': p['ProvAbbr'],
                'ProvFeeSched': prov_fs, 'ProcFee': float(p['ProcFee']),
                'OldShare': float(p['Share']), 'NewShare': provider_share,
                'MatchedVia': matched_via,
            })

    # -- PHASE 3: REPORT --------------------------------------------
    print(f"  Correctly 0 (no share in fee): {unchanged}")
    print(f"  Needs fix (0 -> non-zero):      {len(fixes)}")
    if no_fee:
        print(f"  No fee entry found (skipped):   {len(no_fee)}")

    if not fixes:
        print()
        print("  No fixes needed.")
        conn.close()
        return

    print()
    print("=" * 72)
    print("  PROCEDURES THAT WILL BE FIXED:")
    print("=" * 72)
    for i, f in enumerate(fixes):
        print(f"""
  [{i+1}] ProcNum = {f['ProcNum']}
       Patient  : {f['PatName']}
       Date     : {f['ProcDate']}
       Code     : {f['ProcCode']} - {f['Descript']}
       ProcFee  : Rp{f['ProcFee']:,.0f}
       Provider : {f['ProvAbbr']} (FeeSched={f['ProvFeeSched']})
       Share    : 0  -->  Rp{f['NewShare']:,.0f}   [via: {f['MatchedVia']}]
       SQL      : UPDATE procedurelog SET Share={f['NewShare']} WHERE ProcNum={f['ProcNum']};
""")

    # -- PHASE 4: APPLY ---------------------------------------------
    print("=" * 72)
    if DRY_RUN:
        print("  DRY-RUN complete. No changes were made.")
        print("  To apply, re-run with: --apply")
    else:
        print(f"  [4/4] Applying {len(fixes)} fixes...")
        for f in fixes:
            c2 = conn.cursor()
            c2.execute("UPDATE procedurelog SET Share = %s WHERE ProcNum = %s",
                        (f['NewShare'], f['ProcNum']))
            c2.close()
        conn.commit()
        print(f"  [OK] Updated {len(fixes)} procedures.")
        if no_fee:
            print(f"  [WARN] {len(no_fee)} procedures skipped (no fee entry)")
    print("=" * 72)
    conn.close()


if __name__ == '__main__':
    try:
        main()
    except Exception as e:
        print()
        print("=" * 72)
        print("  UNEXPECTED ERROR:")
        traceback.print_exc()
        print("=" * 72)
    finally:
        print()
        input("Press Enter to exit...")

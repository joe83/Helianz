"""
Fix procedurelog.Share=0 for July 2026 procedures.

BUG: In legacy code, Share was calculated using the patient's primary provider's 
fee schedule instead of the procedure's actual provider. 
When a specialist provider (ProviderShare=0) was the patient's primary, 
procedures done by non-specialist providers would get Share=0 incorrectly.

FIX: Recalculate Share using the procedure's actual ProvNum, 
matching the fee table lookup logic from Fees.GetFeeFromDb().
"""
import mysql.connector
from datetime import date

DB_HOST = 'localhost'
DB_USER = 'root'
DB_PASS = 'J0k0m4r0k3@'
DB_NAME = 'helianz_klt'

# July 2026 range
DATE_FROM = '2026-07-01'
DATE_TO   = '2026-07-31'

conn = mysql.connector.connect(host=DB_HOST, user=DB_USER, password=DB_PASS, database=DB_NAME)
c = conn.cursor(buffered=True, dictionary=True)

# ============================================================
# PHASE 1: SCAN - Find procedures with Share=0 in July 2026
# ============================================================
print("=" * 70)
print("PHASE 1: SCANNING for procedures with Share=0 in July 2026")
print("=" * 70)

c.execute("""
    SELECT 
        pl.ProcNum,
        pl.PatNum,
        pl.ProvNum AS ProcProvNum,
        pl.CodeNum,
        pl.ProcFee,
        pl.Share,
        pl.ClinicNum,
        pl.ProcDate,
        pl.ProcStatus,
        pc.ProcCode,
        pc.Descript,
        pt.LName AS PatLName,
        pt.FName AS PatFName,
        pt.PriProv AS PatPriProv,
        pv.LName AS ProvLName,
        pv.Abbr AS ProvAbbr,
        pv.FeeSched AS ProvFeeSched,
        pv.Specialty AS ProvSpecialty
    FROM procedurelog pl
    JOIN procedurecode pc ON pl.CodeNum = pc.CodeNum
    JOIN patient pt ON pl.PatNum = pt.PatNum
    JOIN provider pv ON pl.ProvNum = pv.ProvNum
    WHERE pl.Share = 0 
      AND pl.ProcFee > 0
      AND pl.ProcStatus = 2  -- Completed
      AND pl.ProcDate >= %s 
      AND pl.ProcDate <= %s
    ORDER BY pl.ProcDate, pl.PatNum
""", (DATE_FROM, DATE_TO))

procs = c.fetchall()
print(f"\nFound {len(procs)} completed procedures with Share=0 in July 2026.\n")

if not procs:
    print("Nothing to fix. Exiting.")
    conn.close()
    exit()

# Show summary grouped by provider
prov_summary = {}
for p in procs:
    prov_key = f"{p['ProvAbbr']} (ProvNum={p['ProcProvNum']})"
    if prov_key not in prov_summary:
        prov_summary[prov_key] = {'count': 0, 'total_fee': 0, 'patients': set()}
    prov_summary[prov_key]['count'] += 1
    prov_summary[prov_key]['total_fee'] += p['ProcFee']
    prov_summary[prov_key]['patients'].add(f"{p['PatFName']} {p['PatLName']}")

print("--- Summary by Procedure Provider ---")
for prov, info in sorted(prov_summary.items()):
    print(f"  {prov}: {info['count']} procs, total fee Rp{info['total_fee']:,.0f}")
    print(f"    Patients: {', '.join(sorted(info['patients']))}")
print()

# Show detail for each procedure
print("--- Detail ---")
for p in procs:
    print(f"  ProcNum={p['ProcNum']} | {p['ProcDate']} | {p['PatFName']} {p['PatLName']}")
    print(f"    Code: {p['ProcCode']} ({p['Descript']})")
    print(f"    ProcFee={p['ProcFee']:,.0f}  Share={p['Share']}")
    print(f"    Proc Provider: {p['ProvAbbr']} (ProvNum={p['ProcProvNum']}, FeeSched={p['ProvFeeSched']})")
    print(f"    Pat Primary Prov: ProvNum={p['PatPriProv']}")
print()

# ============================================================
# PHASE 2: Calculate correct Share for each procedure
# ============================================================
print("=" * 70)
print("PHASE 2: CALCULATING correct Share values")
print("=" * 70)

fixes = []  # list of (ProcNum, oldShare, newShare)
no_fee_found = []

for p in procs:
    proc_num = p['ProcNum']
    code_num = p['CodeNum']
    clinic_num = p['ClinicNum']
    prov_num = p['ProcProvNum']
    prov_fee_sched = p['ProvFeeSched']
    
    # Mimic Fees.GetFeeFromDb logic:
    # 1. Exact match: CodeNum + FeeSched + ClinicNum + ProvNum
    # 2. Provider override: CodeNum + FeeSched + clinic=0 + ProvNum
    # 3. Clinic override: CodeNum + FeeSched + ClinicNum + prov=0
    # 4. HQ (no override): CodeNum + FeeSched + clinic=0 + prov=0
    
    provider_share = None
    matched_via = None
    
    # Build feeSched filter
    if prov_fee_sched > 0:
        fee_sched_filter = "AND FeeSched = %s"
        fee_sched_params = [code_num, prov_fee_sched, clinic_num, prov_num]
    else:
        fee_sched_filter = ""
        fee_sched_params = [code_num, clinic_num, prov_num]
    
    # Try exact match first
    c.execute(f"""
        SELECT ProviderShare FROM fee 
        WHERE CodeNum = %s {fee_sched_filter}
          AND ClinicNum = %s AND ProvNum = %s
        LIMIT 1
    """, fee_sched_params)
    row = c.fetchone()
    if row:
        provider_share = row['ProviderShare']
        matched_via = 'exact'
    
    # Try provider override (clinic=0)
    if provider_share is None and prov_num > 0:
        c.execute(f"""
            SELECT ProviderShare FROM fee 
            WHERE CodeNum = %s {fee_sched_filter}
              AND ClinicNum = 0 AND ProvNum = %s
            LIMIT 1
        """, [code_num, prov_fee_sched, prov_num] if prov_fee_sched > 0 else [code_num, prov_num])
        row = c.fetchone()
        if row:
            provider_share = row['ProviderShare']
            matched_via = 'provider_override'
    
    # Try clinic override (prov=0)
    if provider_share is None and clinic_num > 0:
        c.execute(f"""
            SELECT ProviderShare FROM fee 
            WHERE CodeNum = %s {fee_sched_filter}
              AND ClinicNum = %s AND ProvNum = 0
            LIMIT 1
        """, [code_num, prov_fee_sched, clinic_num] if prov_fee_sched > 0 else [code_num, clinic_num])
        row = c.fetchone()
        if row:
            provider_share = row['ProviderShare']
            matched_via = 'clinic_override'
    
    # Try HQ (clinic=0, prov=0)
    if provider_share is None:
        c.execute(f"""
            SELECT ProviderShare FROM fee 
            WHERE CodeNum = %s {fee_sched_filter}
              AND ClinicNum = 0 AND ProvNum = 0
            LIMIT 1
        """, [code_num, prov_fee_sched] if prov_fee_sched > 0 else [code_num])
        row = c.fetchone()
        if row:
            provider_share = row['ProviderShare']
            matched_via = 'hq'
    
    if provider_share is not None:
        print(f"  ProcNum={proc_num} | Share: {p['Share']} -> {provider_share:,.0f} | via: {matched_via}")
        fixes.append((proc_num, p['Share'], provider_share))
    else:
        # Try without feeSched filter (any fee schedule)
        c.execute("""
            SELECT f.ProviderShare, fs.Description AS FeeSchedDesc
            FROM fee f
            LEFT JOIN feesched fs ON f.FeeSched = fs.FeeSchedNum
            WHERE f.CodeNum = %s AND f.ClinicNum = %s AND f.ProvNum = %s
            LIMIT 1
        """, (code_num, clinic_num, prov_num))
        row = c.fetchone()
        if row:
            provider_share = row['ProviderShare']
            print(f"  ProcNum={proc_num} | Share: {p['Share']} -> {provider_share:,.0f} | via: fallback (any FeeSched={row['FeeSchedDesc']})")
            fixes.append((proc_num, p['Share'], provider_share))
        else:
            print(f"  ProcNum={proc_num} | NO FEE FOUND for CodeNum={code_num}, ClinicNum={clinic_num}, ProvNum={prov_num}")
            no_fee_found.append(proc_num)

print(f"\nFound correct Share for {len(fixes)} procedures.")
if no_fee_found:
    print(f"WARNING: {len(no_fee_found)} procedures have NO fee entry — cannot fix!")

# ============================================================
# PHASE 3: Apply fixes
# ============================================================
if not fixes:
    print("\nNo fixes to apply. Exiting.")
    conn.close()
    exit()

print("\n" + "=" * 70)
print("PHASE 3: APPLYING fixes")
print("=" * 70)

confirm = input(f"\nApply Share fix for {len(fixes)} procedures? (yes/no): ").strip().lower()
if confirm != 'yes':
    print("Aborted by user.")
    conn.close()
    exit()

updated = 0
for proc_num, old_share, new_share in fixes:
    c2 = conn.cursor()
    c2.execute("UPDATE procedurelog SET Share = %s WHERE ProcNum = %s", (new_share, proc_num))
    c2.close()
    updated += 1

conn.commit()
print(f"\nUpdated {updated} procedures with correct Share values.")
if no_fee_found:
    print(f"WARNING: {len(no_fee_found)} procedures could not be fixed (no fee entry found):")
    for pn in no_fee_found:
        print(f"  - ProcNum={pn}")

conn.close()
print("\nDone.")

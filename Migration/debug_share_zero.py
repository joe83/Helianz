"""Diagnose why Share is still 0 for new procedures"""
import mysql.connector

conn = mysql.connector.connect(host='localhost', user='root', password='J0k0m4r0k3@', database='helianz_klt')
c = conn.cursor(buffered=True, dictionary=True)

# Check: For July 27 procedures we fixed, what was the patient's FeeSched?
print('=== Patients with fixed Share=0 procedures in July 2026 ===')
c.execute("""
    SELECT DISTINCT pt.PatNum, pt.LName, pt.FName, pt.PriProv, pt.FeeSched AS PatFeeSched,
           pp.Abbr AS PriProvAbbr, pp.FeeSched AS PriProvFeeSched
    FROM procedurelog pl
    JOIN patient pt ON pl.PatNum = pt.PatNum
    JOIN provider pp ON pt.PriProv = pp.ProvNum
    WHERE pl.Share = 0 AND pl.ProcFee > 0 AND pl.ProcStatus = 2
      AND pl.ProcDate >= '2026-07-01' AND pl.ProcDate <= '2026-07-31'
    LIMIT 15
""")
rows = c.fetchall()
for r in rows:
    print(f"  PatNum={r['PatNum']} | {r['FName']} {r['LName']} | PatFeeSched={r['PatFeeSched']} | PriProv={r['PriProvAbbr']} (ProvNum={r['PriProv']}, FeeSched={r['PriProvFeeSched']})")

# Now check the specific patients that got non-zero fix
print()
print('=== FeeSched debug: IsGlobal ===')
c.execute('SELECT FeeSchedNum, Description, IsGlobal FROM feesched ORDER BY FeeSchedNum')
for r in c.fetchall():
    print(f"  FeeSched={r['FeeSchedNum']} | {r['Description']} | IsGlobal={r['IsGlobal']}")

# Check fee entries for BM22 under FeeSched=56 and FeeSched=57
print()
print('=== Fee entries for BM22 ===')
c.execute("SELECT CodeNum, ProcCode FROM procedurecode WHERE ProcCode='BM22'")
pc = c.fetchone()
if pc:
    cn = pc['CodeNum']
    c.execute("""
        SELECT f.FeeSched, fs.Description, f.ClinicNum, f.ProvNum, f.Amount, f.ProviderShare
        FROM fee f JOIN feesched fs ON f.FeeSched = fs.FeeSchedNum
        WHERE f.CodeNum = %s ORDER BY f.FeeSched, f.ClinicNum, f.ProvNum
    """, (cn,))
    for r in c.fetchall():
        print(f"  FeeSched={r['FeeSched']} ({r['Description']}) Clinic={r['ClinicNum']} Prov={r['ProvNum']} Amount={r['Amount']} ProviderShare={r['ProviderShare']}")

# Find Adelyya's patient record
print()
print('=== Simulating GetFeeSched for Adelyya ===')
c.execute("SELECT PatNum, FeeSched, PriProv, LName, FName FROM patient WHERE LName LIKE '%Adelyya%' OR FName LIKE '%Adelyya%'")
pat = c.fetchone()
if pat:
    print(f"  Patient: PatNum={pat['PatNum']} {pat['FName']} {pat['LName']} FeeSched={pat['FeeSched']} PriProv={pat['PriProv']}")
    # Simulate GetFeeSched(0, pat.FeeSched, 23)
    c.execute('SELECT FeeSched FROM provider WHERE ProvNum=23')
    p23 = c.fetchone()
    prov_fs_23 = p23['FeeSched'] if p23 else 0
    c.execute('SELECT FeeSched FROM provider WHERE ProvNum=1')
    p1 = c.fetchone()
    prov_fs_1 = p1['FeeSched'] if p1 else 0
    print(f"  ProvNum=23 (drg Rizky) FeeSched={prov_fs_23}")
    print(f"  ProvNum=1 (drg Prima) FeeSched={prov_fs_1}")
    # GetFeeSched(0, pat.FeeSched, 23) = First non-zero of [0, pat.FeeSched, provFeeSched(23)]
    result = next((x for x in [0, pat['FeeSched'], prov_fs_23] if x > 0), 0)
    print(f"  GetFeeSched(priPlan=0, patFeeSched={pat['FeeSched']}, provNumProc=23) = {result}")
    if pat['FeeSched'] > 0:
        print(f"  *** BUG: pat.FeeSched={pat['FeeSched']} OVERRIDES procedure provider FeeSched={prov_fs_23}! ***")
    else:
        print(f"  OK: pat.FeeSched=0, falls through to provFeeSched={prov_fs_23}")

# Check all affected patients with non-zero fixes
print()
print('=== Checking patient.FeeSched for ALL patients with non-zero fixes ===')
c.execute("""
    SELECT DISTINCT pt.PatNum, pt.LName, pt.FName, pt.PriProv, pt.FeeSched,
           pp.Abbr AS PriProvAbbr, pp.FeeSched AS PriProvFS
    FROM procedurelog pl
    JOIN patient pt ON pl.PatNum = pt.PatNum
    JOIN provider pp ON pt.PriProv = pp.ProvNum
    WHERE pl.ProcNum IN (227045, 227116, 227229, 227230, 227231, 227258, 227437,
                         227589, 227601, 227688, 227687, 227767, 228654)
""")
for r in c.fetchall():
    flag = " *** BUG if FeeSched>0!" if r['FeeSched'] > 0 else ""
    print(f"  PatNum={r['PatNum']} | {r['FName']} {r['LName']} | Patient.FeeSched={r['FeeSched']} | PriProv={r['PriProvAbbr']} (FS={r['PriProvFS']}){flag}")

conn.close()

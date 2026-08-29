import pymysql

conn = pymysql.connect(
    host='localhost',
    user='root',
    password='J0k0m4r0k3@',
    database='helianz_klt',
    cursorclass=pymysql.cursors.DictCursor
)
cur = conn.cursor()

query = '''
SELECT 
    pl.ProcNum,
    pl.ProcDate,
    pl.PatNum,
    CONCAT(p.LName, ', ', p.FName, ' ', p.MiddleI) AS PatName,
    pc.ProcCode,
    pc.Descript,
    pl.ToothNum,
    pl.ProcFee,
    pr.Abbr AS ProcProvAbbr,
    pr_pat.Abbr AS PatPriProvAbbr,
    fs.Description AS FeeSchedDesc,
    pl.Share AS CurrentShare,
    COALESCE(f_exact.ProviderShare, f_prov.ProviderShare, f_clinic.ProviderShare, f_hq.ProviderShare, 0) AS ExpectedShare
FROM procedurelog pl
INNER JOIN patient p ON pl.PatNum = p.PatNum
INNER JOIN procedurecode pc ON pl.CodeNum = pc.CodeNum
INNER JOIN provider pr ON pl.ProvNum = pr.ProvNum
LEFT JOIN feesched fs ON pr.FeeSched = fs.FeeSchedNum
LEFT JOIN provider pr_pat ON p.PriProv = pr_pat.ProvNum
LEFT JOIN clinic cl ON pl.ClinicNum = cl.ClinicNum
LEFT JOIN fee f_exact ON f_exact.CodeNum = pl.CodeNum 
    AND f_exact.FeeSched = pr.FeeSched 
    AND f_exact.ClinicNum = pl.ClinicNum 
    AND f_exact.ProvNum = pl.ProvNum
LEFT JOIN fee f_prov ON f_prov.CodeNum = pl.CodeNum 
    AND f_prov.FeeSched = pr.FeeSched 
    AND f_prov.ClinicNum = 0 
    AND f_prov.ProvNum = pl.ProvNum
LEFT JOIN fee f_clinic ON f_clinic.CodeNum = pl.CodeNum 
    AND f_clinic.FeeSched = pr.FeeSched 
    AND f_clinic.ClinicNum = pl.ClinicNum 
    AND f_clinic.ProvNum = 0
LEFT JOIN fee f_hq ON f_hq.CodeNum = pl.CodeNum 
    AND f_hq.FeeSched = pr.FeeSched 
    AND f_hq.ClinicNum = 0 
    AND f_hq.ProvNum = 0
WHERE pl.ProcStatus = 2
  AND pl.ProcFee > 0
  AND pl.ProcDate >= '2026-08-01'
  AND pl.ProcDate <= '2026-08-31'
  AND pl.Share = 0
  AND COALESCE(f_exact.ProviderShare, f_prov.ProviderShare, f_clinic.ProviderShare, f_hq.ProviderShare, 0) > 0
ORDER BY pl.ProcDate, PatName, pc.ProcCode
'''

cur.execute(query)
rows = cur.fetchall()
print('=== MISMATCHED PROCEDURES IN AUGUST 2026 ===')
print('Total Found:', len(rows))
total_fee = sum(r['ProcFee'] for r in rows)
total_share = sum(r['ExpectedShare'] for r in rows)
for i, r in enumerate(rows, 1):
    print(f"{i:02d} | ProcNum {r['ProcNum']} | {r['ProcDate']} | Pat {r['PatNum']} ({r['PatName']}) | {r['ProcCode']} - {r['Descript'][:20]} | Prov: {r['ProcProvAbbr']} (Pri: {r['PatPriProvAbbr']}) | Fee: Rp {r['ProcFee']:,.0f} | Cur: Rp {r['CurrentShare']:,.0f} | Exp: Rp {r['ExpectedShare']:,.0f}")
print(f"Total Fee: Rp {total_fee:,.0f} | Total Doctor Share to Recover: Rp {total_share:,.0f}")

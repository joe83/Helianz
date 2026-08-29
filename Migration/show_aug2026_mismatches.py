import mysql.connector

conn = mysql.connector.connect(host='localhost', user='root', password='J0k0m4r0k3@', database='helianz_klt')
c = conn.cursor(dictionary=True)

query = '''
SELECT 
    pl.ProcNum, pl.ProcDate, pl.PatNum, CONCAT(p.FName, ' ', p.LName) AS PatientName,
    p.PriProv AS PatPriProvNum, pr_pat.Abbr AS PatPriProvAbbr, pr_pat.FeeSched AS PatPriProvFS,
    pl.ProvNum AS ProcProvNum, pr_proc.Abbr AS ProcProvAbbr, pr_proc.FeeSched AS ProcProvFS,
    pl.CodeNum, pc.ProcCode, pc.Descript, pl.ProcFee, pl.Share, pl.ClinicNum
FROM procedurelog pl
JOIN patient p ON pl.PatNum = p.PatNum
LEFT JOIN provider pr_pat ON p.PriProv = pr_pat.ProvNum
LEFT JOIN provider pr_proc ON pl.ProvNum = pr_proc.ProvNum
LEFT JOIN procedurecode pc ON pl.CodeNum = pc.CodeNum
WHERE pl.ProcDate >= '2026-08-01' AND pl.ProcDate <= '2026-08-31'
  AND pl.ProcStatus = 2
  AND pl.ProcFee > 0
  AND pl.Share = 0
ORDER BY pl.ProcDate, pl.PatNum;
'''

c.execute(query)
procs = c.fetchall()

mismatches = []
for p in procs:
    c.execute('SELECT FeeSched, Amount, ProviderShare FROM fee WHERE CodeNum=%s AND FeeSched=%s', (p['CodeNum'], p['ProcProvFS']))
    f = c.fetchone()
    if f and f['ProviderShare'] > 0:
        p['expected_share'] = f['ProviderShare']
        mismatches.append(p)

print('=' * 80)
print(f'MISMATCHED SHARE=0 PROCEDURES IN AUGUST 2026: {len(mismatches)}')
print('=' * 80)
for i, m in enumerate(mismatches, 1):
    print(f"[{i}] ProcNum: {m['ProcNum']} | Date: {m['ProcDate']}")
    print(f"    Patient     : {m['PatientName']} (PatNum: {m['PatNum']})")
    print(f"    Primary Prov: {m['PatPriProvAbbr']} (FS {m['PatPriProvFS']})")
    print(f"    Proc Prov   : {m['ProcProvAbbr']} (FS {m['ProcProvFS']})")
    print(f"    Procedure   : {m['ProcCode']} - {m['Descript']}")
    print(f"    ProcFee     : Rp {m['ProcFee']:,.0f}")
    print(f"    Share in DB : Rp {m['Share']:,.0f}  --> Expected Share: Rp {m['expected_share']:,.0f}")
    print('-' * 80)

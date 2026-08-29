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
ORDER BY pl.ProcDate, pl.PatNum;
'''

c.execute(query)
procs = c.fetchall()

print(f'Total completed procedures with Fee > 0 in August 2026: {len(procs)}')

zero_share = []
for p in procs:
    if p['Share'] == 0:
        c.execute('SELECT FeeSched, Amount, ProviderShare FROM fee WHERE CodeNum=%s', (p['CodeNum'],))
        fees = c.fetchall()
        
        proc_prov_fs = p['ProcProvFS']
        pat_pri_fs = p['PatPriProvFS']
        
        share_in_proc_prov_fs = None
        share_in_pat_pri_fs = None
        for f in fees:
            if f['FeeSched'] == proc_prov_fs:
                share_in_proc_prov_fs = f['ProviderShare']
            if f['FeeSched'] == pat_pri_fs:
                share_in_pat_pri_fs = f['ProviderShare']
                
        p['fees'] = fees
        p['share_in_proc_prov_fs'] = share_in_proc_prov_fs
        p['share_in_pat_pri_fs'] = share_in_pat_pri_fs
        zero_share.append(p)

print(f'Total procedures with Share == 0: {len(zero_share)}')
print()
print('=== Procedures with Share == 0 where Procedure Provider FeeSched has ProviderShare > 0 ===')
mismatches = [p for p in zero_share if p['share_in_proc_prov_fs'] and p['share_in_proc_prov_fs'] > 0]
print(f'Count: {len(mismatches)}')
for i, m in enumerate(mismatches, 1):
    pat = m['PatientName']
    pat_num = m['PatNum']
    pri = m['PatPriProvAbbr']
    pri_fs = m['PatPriProvFS']
    proc_p = m['ProcProvAbbr']
    proc_fs = m['ProcProvFS']
    code = m['ProcCode']
    desc = m['Descript']
    fee = m['ProcFee']
    exp = m['share_in_proc_prov_fs']
    pnum = m['ProcNum']
    pdate = m['ProcDate']
    print(f"[{i}] ProcNum: {pnum} | Date: {pdate} | Patient: {pat} (#{pat_num})")
    print(f"    Primary Prov: {pri} (FS {pri_fs}) | Performed By: {proc_p} (FS {proc_fs})")
    print(f"    Code: {code} ({desc}) | Fee: Rp {fee:,.0f} | Current Share: 0 -> Expected Share: Rp {exp:,.0f}")
    print()


print()
print('=== Procedures with Share == 0 where Procedure Provider FeeSched has ProviderShare == 0 (Legitimate 0 share, e.g. Ortho kit / Elastic) ===')
legit_zero = [p for p in zero_share if not p['share_in_proc_prov_fs'] or p['share_in_proc_prov_fs'] == 0]
print(f'Count: {len(legit_zero)}')
for lz in legit_zero:
    print(f"ProcNum={lz['ProcNum']} | Date={lz['ProcDate']} | Pat={lz['PatientName']} | ProcProv={lz['ProcProvAbbr']} | Code={lz['ProcCode']} ({lz['Descript']}) | Fee={lz['ProcFee']}")

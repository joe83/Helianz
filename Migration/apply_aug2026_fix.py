import pymysql

conn = pymysql.connect(
    host='localhost',
    user='root',
    password='J0k0m4r0k3@',
    database='helianz_klt',
    autocommit=True,
    cursorclass=pymysql.cursors.DictCursor
)
cur = conn.cursor()

fix_sql = '''
UPDATE procedurelog pl
INNER JOIN provider pr ON pl.ProvNum = pr.ProvNum
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
SET pl.Share = COALESCE(f_exact.ProviderShare, f_prov.ProviderShare, f_clinic.ProviderShare, f_hq.ProviderShare, 0)
WHERE pl.ProcNum IN (229205, 229271, 229336, 229335, 229295, 229441, 229440, 229439, 229563, 229850, 231039, 231038, 231318, 231160, 231159)
  AND COALESCE(f_exact.ProviderShare, f_prov.ProviderShare, f_clinic.ProviderShare, f_hq.ProviderShare, 0) > 0
'''

cur.execute(fix_sql)
print('Rows updated:', cur.rowcount)

# Verify now that zero-share mismatches are 0
check_sql = '''
SELECT pl.ProcNum, pl.ProcDate, pl.PatNum, pc.ProcCode, pr.Abbr AS ProvAbbr, pl.ProcFee, pl.Share
FROM procedurelog pl
INNER JOIN provider pr ON pl.ProvNum = pr.ProvNum
INNER JOIN procedurecode pc ON pl.CodeNum = pc.CodeNum
WHERE pl.ProcNum IN (229205, 229271, 229336, 229335, 229295, 229441, 229440, 229439, 229563, 229850, 231039, 231038, 231318, 231160, 231159)
ORDER BY pl.ProcDate, pl.PatNum
'''
cur.execute(check_sql)
updated_rows = cur.fetchall()
print('=== UPDATED RECORDS STATUS ===')
for r in updated_rows:
    print(f"ProcNum {r['ProcNum']}: Date {r['ProcDate']}, Pat {r['PatNum']}, Code {r['ProcCode']}, Prov {r['ProvAbbr']}, Fee Rp {r['ProcFee']:,.0f}, Share Rp {r['Share']:,.0f}")

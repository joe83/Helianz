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
    pl.ProcDate,
    CONCAT(p.LName, ', ', p.FName) AS PatName,
    pc.ProcCode,
    pc.Descript,
    pr.Abbr AS Doctor,
    pl.ProcFee,
    pl.Share AS DoctorShare
FROM procedurelog pl
INNER JOIN patient p ON pl.PatNum = p.PatNum
INNER JOIN procedurecode pc ON pl.CodeNum = pc.CodeNum
INNER JOIN provider pr ON pl.ProvNum = pr.ProvNum
WHERE pl.ProcDate = '2026-08-04' AND pl.ProcStatus = 2
ORDER BY pl.PatNum, pc.ProcCode
'''
cur.execute(query)
rows = cur.fetchall()
print('=== PROCEDURES REPORT ON 04/08/2026 ===')
for r in rows:
    print(f"{r['PatName']:<30} | {r['ProcCode']:<5} | {r['Descript']:<25} | Dr: {r['Doctor']:<12} | Fee: Rp {r['ProcFee']:>9,.0f} | Share: Rp {r['DoctorShare']:>8,.0f}")

import pymysql

c = pymysql.connect(host='localhost', user='root', password='J0k0m4r0k3@', database='helianz', cursorclass=pymysql.cursors.DictCursor)
with c.cursor() as cur:
    cur.execute('SELECT DefNum, ItemOrder, ItemName, IsHidden FROM definition WHERE Category=11 ORDER BY ItemOrder')
    print('=== DEFINITION ===')
    for r in cur.fetchall():
        print(f"{r['DefNum']}: {r['ItemName']} hidden={r['IsHidden']}")
    cur.execute('SELECT ClinicNum, DefNum, ItemName, IsHidden FROM clinic_def WHERE Category=11 ORDER BY ClinicNum, ItemOrder')
    print('=== CLINIC_DEF ===')
    for r in cur.fetchall():
        print(f"C{r['ClinicNum']} {r['DefNum']}: {r['ItemName']} hidden={r['IsHidden']}")

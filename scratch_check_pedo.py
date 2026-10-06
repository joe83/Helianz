import pymysql

conn = pymysql.connect(host='localhost', user='root', password='J0k0m4r0k3@', charset='utf8mb4', cursorclass=pymysql.cursors.DictCursor)
with conn.cursor() as cur:
    for db in ['helianz_klt', 'helianz_byl', 'helianz_jog']:
        cur.execute(f"SHOW DATABASES LIKE '{db}'")
        if cur.fetchone():
            cur.execute(f"SELECT DefNum, ItemName, IsHidden FROM `{db}`.definition WHERE Category=11 AND LOWER(ItemName) LIKE '%pedo%'")
            print(db, cur.fetchall())
            cur.execute(f"SELECT count(*) as c FROM `{db}`.procedurecode p JOIN `{db}`.definition d ON p.ProcCat = d.DefNum WHERE LOWER(d.ItemName) LIKE '%pedo%'")
            print(f"{db} proc count in pedo:", cur.fetchone())

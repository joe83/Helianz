import pymysql

def check():
    for db in ['helianz', 'helianz_klt', 'helianz_byl', 'helianz_jog']:
        c = pymysql.connect(host='localhost', user='root', password='J0k0m4r0k3@', database=db, cursorclass=pymysql.cursors.DictCursor)
        with c.cursor() as cur:
            cur.execute("SELECT UserNum, UserName, ClinicNum, ClinicIsRestricted FROM userod WHERE LOWER(UserName) LIKE '%admin%' OR UserNum IN (1, 18, 3000001)")
            print(f"=== {db} ===")
            for r in cur.fetchall():
                print(r)

if __name__ == '__main__':
    check()

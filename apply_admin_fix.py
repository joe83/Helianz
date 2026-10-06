import pymysql

def run():
    conn = pymysql.connect(host='localhost', user='root', password='J0k0m4r0k3@', database='helianz', cursorclass=pymysql.cursors.DictCursor)
    with conn.cursor() as cur:
        # 1. Update Admin and Owner in userod: unrestricted, default clinic 1
        cur.execute("""
            UPDATE userod 
            SET ClinicIsRestricted = 0, ClinicNum = 1, UserGroupNum = 1 
            WHERE LOWER(UserName) IN ('admin', 'owner')
        """)
        print('Updated userod for Admin and Owner, rows affected:', cur.rowcount)
        
        # 2. Get UserNums for Admin, Owner, and endru
        cur.execute("SELECT UserNum, UserName FROM userod WHERE LOWER(UserName) IN ('admin', 'owner', 'endru')")
        admins = cur.fetchall()
        print('Admin users:', admins)
        
        # 3. Give Admin, Owner, and endru access to ALL clinics (1, 2, 3) in userclinic
        for u in admins:
            uid = u['UserNum']
            uname = u['UserName']
            for cnum in [1, 2, 3]:
                cur.execute('SELECT 1 FROM userclinic WHERE UserNum=%s AND ClinicNum=%s', (uid, cnum))
                if not cur.fetchone():
                    cur.execute('INSERT INTO userclinic (UserNum, ClinicNum) VALUES (%s, %s)', (uid, cnum))
                    print(f'Added Clinic {cnum} for {uname} (UserNum {uid})')
            # Ensure in usergroupattach for UserGroup 1
            cur.execute('SELECT 1 FROM usergroupattach WHERE UserNum=%s AND UserGroupNum=1', (uid,))
            if not cur.fetchone():
                cur.execute('INSERT INTO usergroupattach (UserNum, UserGroupNum) VALUES (%s, 1)', (uid,))
                print(f'Added UserGroup 1 for {uname}')
                
        # 4. Deduplicate grouppermission
        cur.execute("""
            DELETE gp1 FROM grouppermission gp1
            INNER JOIN grouppermission gp2 
            WHERE gp1.UserGroupNum = gp2.UserGroupNum 
              AND gp1.PermType = gp2.PermType 
              AND gp1.FKey = gp2.FKey 
              AND gp1.GroupPermNum > gp2.GroupPermNum
        """)
        print('Deduplicated grouppermission, removed duplicates:', cur.rowcount)
        
        conn.commit()

if __name__ == '__main__':
    run()

import mysql.connector
conn = mysql.connector.connect(host='localhost', user='root', password='J0k0m4r0k3@', database='helianz')
c = conn.cursor()

# Hide boyolali's ADMIN user (UserNum=2000018) that has no password
c.execute("UPDATE userod SET IsHidden=1 WHERE UserNum=2000018 AND Password='' AND UserName='ADMIN'")
conn.commit()
print(f"Hidden ADMIN user 2000018: {c.rowcount} rows affected")

# Verify
c.execute("SELECT UserNum, UserName, Password, IsHidden FROM userod WHERE UserName='ADMIN' OR Password=''")
print("\nADMIN/empty-password users:")
for r in c.fetchall():
    pwd = "(empty)" if not r[2] else "has password"
    print(f"  UserNum={r[0]} Name={r[1]:<18} {pwd} Hidden={r[3]}")

conn.close()

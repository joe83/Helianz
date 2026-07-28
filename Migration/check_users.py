import mysql.connector
conn = mysql.connector.connect(host='localhost', user='root', password='J0k0m4r0k3@', database='helianz')
c = conn.cursor()

c.execute('SELECT UserNum, UserName, Password, IsHidden, ClinicNum FROM userod ORDER BY UserNum')
for r in c.fetchall():
    pwd = r[2]
    if pwd and len(pwd) > 20:
        pwd_show = pwd[:20] + "..."
    elif pwd:
        pwd_show = pwd
    else:
        pwd_show = "(empty)"
    print(f"UserNum={r[0]} Name={r[1]:<18} Password={pwd_show} Hidden={r[3]} Clinic={r[4]}")

# Check for duplicate users
print()
c.execute("SELECT UserName, COUNT(*) FROM userod GROUP BY UserName HAVING COUNT(*) > 1")
dups = c.fetchall()
if dups:
    print("DUPLICATE USERS:")
    for d in dups:
        print(f"  {d[0]}: {d[1]} rows")
else:
    print("No duplicate usernames.")

conn.close()

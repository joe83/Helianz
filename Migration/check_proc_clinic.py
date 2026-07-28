import mysql.connector
conn = mysql.connector.connect(host='localhost', user='root', password='J0k0m4r0k3@', database='helianz')
c = conn.cursor()

# Check mismatched clinics
c.execute("""
    SELECT p.ClinicNum, c.Description as ProcClinic, pt.ClinicNum as PatClinic, 
           COUNT(*) as cnt
    FROM procedurelog p 
    JOIN patient pt ON p.PatNum = pt.PatNum 
    LEFT JOIN clinic c ON p.ClinicNum = c.ClinicNum
    WHERE p.ClinicNum != pt.ClinicNum AND p.ClinicNum > 0
    GROUP BY p.ClinicNum, pt.ClinicNum 
    ORDER BY cnt DESC
""")
rows = c.fetchall()
if rows:
    print("Procedures where clinic != patient clinic:")
    for r in rows:
        print(f"  ProcClinic={r[0]} ({r[1]})  PatClinic={r[2]}:  {r[3]} procs")
else:
    print("No mismatched procedures found.")

conn.close()

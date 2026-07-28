"""Debug: why does procedure show $0 fee?"""
import mysql.connector
conn = mysql.connector.connect(host='localhost', user='root', password='J0k0m4r0k3@', database='helianz')
c = conn.cursor(buffered=True)

# Rony Sanjaya PatNum 10000000
c.execute("SELECT PatNum, ClinicNum, FeeSched, LName, FName FROM patient WHERE PatNum=10000000")
pat = c.fetchone()
print(f"Patient: PatNum={pat[0]} {pat[4]} {pat[3]}  Clinic={pat[1]}  FeeSched={pat[2]}")
pat_clinic = pat[1]
pat_feesched = pat[2]

# KN21
c.execute("SELECT CodeNum, ProcCode, Descript FROM procedurecode WHERE ProcCode='KN21'")
pc = c.fetchone()
code_num = pc[0]
print(f"Procedure: CodeNum={code_num}  {pc[1]} - {pc[2]}")

# Fee schedules
print("\n=== Fee Schedules ===")
c.execute("SELECT FeeSchedNum, Description, IsGlobal FROM feesched ORDER BY FeeSchedNum")
for r in c.fetchall():
    print(f"  {r[0]}  {r[1]}  IsGlobal={r[2]}")

# Fees for KN21
print(f"\n=== Fees for KN21 (CodeNum={code_num}) ===")
c.execute("""
    SELECT f.FeeSched, fs.Description, f.ClinicNum, f.ProvNum, f.Amount
    FROM fee f LEFT JOIN feesched fs ON f.FeeSched = fs.FeeSchedNum
    WHERE f.CodeNum = %s ORDER BY f.FeeSched, f.ClinicNum
""", (code_num,))
rows = c.fetchall()
if rows:
    for r in rows:
        print(f"  FeeSched={r[0]} ({r[1]})  Clinic={r[2]}  Prov={r[3]}  Amount={r[4]}")
else:
    print("  NO FEES!")

# Simulate GetProcFee
print(f"\n=== GetProcFee simulation ===")
print(f"  Patient FeeSched={pat_feesched}  Procedure ClinicNum=1 (KLT1)")
c.execute("""
    SELECT Amount FROM fee 
    WHERE CodeNum=%s AND FeeSched=%s AND ClinicNum=1 AND ProvNum=0
""", (code_num, pat_feesched))
r = c.fetchone()
if r:
    print(f"  Exact(KLT1): {r[0]}")
else:
    c.execute("""
        SELECT Amount FROM fee WHERE CodeNum=%s AND FeeSched=%s AND ClinicNum=1
    """, (code_num, pat_feesched))
    r = c.fetchone()
    if r:
        print(f"  Clinic1(any prov): {r[0]}")
    else:
        c.execute("""
            SELECT Amount FROM fee WHERE CodeNum=%s AND FeeSched=%s AND ClinicNum=0
        """, (code_num, pat_feesched))
        r = c.fetchone()
        if r:
            print(f"  Clinic0(any): {r[0]}")
        else:
            print("  NO MATCH for patient FeeSched + ClinicNum=1")
            c.execute("SELECT FeeSched FROM clinic WHERE ClinicNum=1")
            clinic_fs = c.fetchone()[0]
            print(f"  Clinic KLT1 own FeeSched = {clinic_fs}")
            c.execute("""
                SELECT Amount FROM fee WHERE CodeNum=%s AND FeeSched=%s AND ClinicNum=1
            """, (code_num, clinic_fs))
            r = c.fetchone()
            if r:
                print(f"  Would match (clinic FeeSched {clinic_fs}): Amount = {r[0]}")

conn.close()

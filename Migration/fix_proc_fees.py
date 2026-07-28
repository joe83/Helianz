"""
Fix stored ProcFee=0 for procedures where clinic mismatches patient.
Uses the procedure's clinic to look up the correct fee.
"""
import mysql.connector

conn = mysql.connector.connect(host='localhost', user='root', password='J0k0m4r0k3@', database='helianz')
c = conn.cursor(buffered=True)

# Find procedures with ProcFee=0 where procedure clinic != patient clinic
c.execute("""
    SELECT p.ProcNum, p.CodeNum, p.ClinicNum as ProcClinic, 
           pt.ClinicNum as PatClinic, p.ProvNum
    FROM procedurelog p
    JOIN patient pt ON p.PatNum = pt.PatNum
    WHERE p.ProcFee = 0 AND p.ProcStatus != 6
      AND p.ClinicNum != pt.ClinicNum
    LIMIT 50
""")
procs = c.fetchall()
print(f"Found {len(procs)} procedures with ProcFee=0 and mismatched clinic")

if not procs:
    print("Nothing to fix.")
    conn.close()
    exit()

updated = 0
for proc_num, code_num, proc_clinic, pat_clinic, prov_num in procs:
    # Find fee: prefer fee for this clinic+code, any fee schedule
    c.execute("""
        SELECT f.Amount FROM fee f
        WHERE f.CodeNum = %s AND f.ClinicNum = %s AND f.ProvNum = 0
        ORDER BY f.FeeSched LIMIT 1
    """, (code_num, proc_clinic))
    fee_row = c.fetchone()
    
    if fee_row and fee_row[0] > 0:
        amount = fee_row[0]
        c2 = conn.cursor()
        c2.execute("UPDATE procedurelog SET ProcFee = %s WHERE ProcNum = %s", (amount, proc_num))
        c2.close()
        updated += 1
        print(f"  ProcNum={proc_num}: ProcFee -> {amount:,.0f}")
    else:
        # Try clinic=0 fallback
        c.execute("""
            SELECT f.Amount FROM fee f
            WHERE f.CodeNum = %s AND f.ClinicNum = 0 AND f.ProvNum = 0
            ORDER BY f.FeeSched LIMIT 1
        """, (code_num,))
        fee_row = c.fetchone()
        if fee_row and fee_row[0] > 0:
            amount = fee_row[0]
            c2 = conn.cursor()
            c2.execute("UPDATE procedurelog SET ProcFee = %s WHERE ProcNum = %s", (amount, proc_num))
            c2.close()
            updated += 1
            print(f"  ProcNum={proc_num}: ProcFee -> {amount:,.0f} (clinic=0 fallback)")
        else:
            print(f"  ProcNum={proc_num}: NO FEE FOUND for code={code_num} clinic={proc_clinic}")

conn.commit()
print(f"\nUpdated {updated} procedures.")
conn.close()

"""Diagnose appointment display issues after clinic segregation."""
import mysql.connector

conn = mysql.connector.connect(host='localhost', user='root', password='J0k0m4r0k3@', database='helianz')
c = conn.cursor(dictionary=True)

print('=== apptviewitem - ALL with non-empty ElementDesc ===')
c.execute("""SELECT avi.ApptViewItemNum, avi.ApptViewNum, avi.ElementDesc, avi.ElementOrder, avi.ClinicNum 
FROM apptviewitem avi WHERE ElementDesc != '' ORDER BY ApptViewNum, ElementOrder""")
for r in c.fetchall(): print(r)

print()
print('=== apptviewitem - check for ClinicNum=0 ===')
c.execute('SELECT ApptViewItemNum, ApptViewNum, ElementDesc, ClinicNum FROM apptviewitem WHERE ClinicNum = 0')
rows0 = c.fetchall()
print(f'Count: {len(rows0)}')
for r in rows0[:5]: print(r)

print()
print('=== apptview - check for ClinicNum=0 ===')
c.execute('SELECT * FROM apptview WHERE ClinicNum = 0')
rows0 = c.fetchall()
print(f'Count: {len(rows0)}')
for r in rows0: print(r)

print()
print('=== Definition - Category 1 (ApptConfirmed colors) ===')
c.execute('SELECT DefNum, ItemValue, ItemColor FROM definition WHERE Category = 1')
for r in c.fetchall(): print(r)

print()
print('=== Definition - Category 2 (ApptProcsColored) ===')
c.execute('SELECT DefNum, ItemValue, ItemColor FROM definition WHERE Category = 2')
for r in c.fetchall(): print(r)

print()
print('=== Definition - Category 4 (ApptStatus) ===')
c.execute('SELECT DefNum, ItemValue, ItemColor, IsHidden FROM definition WHERE Category = 4')
for r in c.fetchall(): print(r)

print()
print('=== apptviewitem ALL columns for ALL rows ===')
c.execute('SELECT * FROM apptviewitem ORDER BY ApptViewNum, ApptViewItemNum')
for r in c.fetchall(): print(r)

print()
print('=== apptview ALL ===')
c.execute('SELECT * FROM apptview')
for r in c.fetchall(): print(r)

print()
print('=== schedule table - ClinicNum distribution ===')
c.execute('SELECT ClinicNum, COUNT(*) FROM schedule GROUP BY ClinicNum')
for r in c.fetchall(): print(r)

print()
print('=== operatory table - ClinicNum distribution ===')
c.execute('SELECT ClinicNum, COUNT(*) FROM operatory GROUP BY ClinicNum')
for r in c.fetchall(): print(r)

c.close()
conn.close()

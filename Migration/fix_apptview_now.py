"""One-off fix: restore correct apptview/userodapptview state for all 3 clinics."""
import mysql.connector

conn = mysql.connector.connect(host='localhost', user='root', password='J0k0m4r0k3@', database='helianz')
c = conn.cursor(dictionary=True)

# Current problem: ApptViewNum 2,3,4 moved to ClinicNum=2. Clinics 1 & 3 have nothing.

# Step 1: Move 2,3,4 back to ClinicNum=1
c.execute('UPDATE apptview SET ClinicNum = 1 WHERE ApptViewNum IN (2,3,4)')
print(f'Restored ApptViewNum 2,3,4 to ClinicNum=1: {c.rowcount} rows')

# Step 2: Create clinic 2 views
c.execute("""INSERT INTO apptview (Description, ItemOrder, RowsPerIncr, OnlyScheduledProvs,
    OnlySchedBeforeTime, OnlySchedAfterTime, StackBehavUR, StackBehavLR,
    ClinicNum, ApptTimeScrollStart, IsScrollStartDynamic, IsApptBubblesDisabled,
    WidthOpMinimum, WaitingRmName, OnlyScheduledProvDays)
    SELECT Description, ItemOrder, RowsPerIncr, OnlyScheduledProvs,
        OnlySchedBeforeTime, OnlySchedAfterTime, StackBehavUR, StackBehavLR,
        2, ApptTimeScrollStart, IsScrollStartDynamic, IsApptBubblesDisabled,
        WidthOpMinimum, WaitingRmName, OnlyScheduledProvDays
    FROM apptview WHERE ClinicNum = 1""")
print(f'Created clinic 2 views: {c.rowcount} rows')

# Step 3: Create clinic 3 views
c.execute("""INSERT INTO apptview (Description, ItemOrder, RowsPerIncr, OnlyScheduledProvs,
    OnlySchedBeforeTime, OnlySchedAfterTime, StackBehavUR, StackBehavLR,
    ClinicNum, ApptTimeScrollStart, IsScrollStartDynamic, IsApptBubblesDisabled,
    WidthOpMinimum, WaitingRmName, OnlyScheduledProvDays)
    SELECT Description, ItemOrder, RowsPerIncr, OnlyScheduledProvs,
        OnlySchedBeforeTime, OnlySchedAfterTime, StackBehavUR, StackBehavLR,
        3, ApptTimeScrollStart, IsScrollStartDynamic, IsApptBubblesDisabled,
        WidthOpMinimum, WaitingRmName, OnlyScheduledProvDays
    FROM apptview WHERE ClinicNum = 1""")
print(f'Created clinic 3 views: {c.rowcount} rows')

# Step 4: Get all ApptViewNums mapped
c.execute('SELECT ApptViewNum, Description, ClinicNum FROM apptview ORDER BY ClinicNum, ApptViewNum')
views = {}
for r in c.fetchall():
    print(f'  ApptViewNum={r["ApptViewNum"]}, {r["Description"]}, ClinicNum={r["ClinicNum"]}')
    views[(r['ClinicNum'], r['Description'])] = r['ApptViewNum']

# Step 5: Clone apptviewitem for clinic 2
for desc in ['All', 'Doc', 'Hyg']:
    src = views.get((1, desc))
    dst = views.get((2, desc))
    if src and dst:
        c.execute(f"""INSERT INTO apptviewitem (ApptViewNum, OpNum, ProvNum, ElementDesc,
            ElementOrder, ElementColor, ElementAlignment, ApptFieldDefNum,
            PatFieldDefNum, IsMobile)
            SELECT {dst}, OpNum, ProvNum, ElementDesc, ElementOrder,
                ElementColor, ElementAlignment, ApptFieldDefNum,
                PatFieldDefNum, IsMobile
            FROM apptviewitem WHERE ApptViewNum = {src}""")
        print(f'  Clinic2 {desc}: cloned {c.rowcount} items')

# Step 6: Clone apptviewitem for clinic 3
for desc in ['All', 'Doc', 'Hyg']:
    src = views.get((1, desc))
    dst = views.get((3, desc))
    if src and dst:
        c.execute(f"""INSERT INTO apptviewitem (ApptViewNum, OpNum, ProvNum, ElementDesc,
            ElementOrder, ElementColor, ElementAlignment, ApptFieldDefNum,
            PatFieldDefNum, IsMobile)
            SELECT {dst}, OpNum, ProvNum, ElementDesc, ElementOrder,
                ElementColor, ElementAlignment, ApptFieldDefNum,
                PatFieldDefNum, IsMobile
            FROM apptviewitem WHERE ApptViewNum = {src}""")
        print(f'  Clinic3 {desc}: cloned {c.rowcount} items')

# Step 7: Fix userodapptview for ALL clinics
all_view_c1 = views.get((1, 'All'), 2)
all_view_c2 = views.get((2, 'All'), 2)
all_view_c3 = views.get((3, 'All'), 2)

# Delete bad entries (ApptViewNum=0)
c.execute('DELETE FROM userodapptview WHERE ApptViewNum = 0')
print(f'Deleted ApptViewNum=0 entries: {c.rowcount} rows')

# Insert correct entries for clinic 1
c.execute(f"""INSERT IGNORE INTO userodapptview (UserNum, ClinicNum, ApptViewNum)
    SELECT u.UserNum, 1, {all_view_c1} FROM userod u
    WHERE u.UserNum NOT IN (SELECT UserNum FROM userodapptview WHERE ClinicNum=1)""")
print(f'userodapptview ClinicNum=1: {c.rowcount} added')

# Insert correct entries for clinic 2
c.execute(f"""INSERT IGNORE INTO userodapptview (UserNum, ClinicNum, ApptViewNum)
    SELECT u.UserNum, 2, {all_view_c2} FROM userod u
    WHERE u.UserNum NOT IN (SELECT UserNum FROM userodapptview WHERE ClinicNum=2)""")
print(f'userodapptview ClinicNum=2: {c.rowcount} added')

# Insert correct entries for clinic 3
c.execute(f"""INSERT IGNORE INTO userodapptview (UserNum, ClinicNum, ApptViewNum)
    SELECT u.UserNum, 3, {all_view_c3} FROM userod u
    WHERE u.UserNum NOT IN (SELECT UserNum FROM userodapptview WHERE ClinicNum=3)""")
print(f'userodapptview ClinicNum=3: {c.rowcount} added')

# Also fix clinic 2 entries that have wrong ApptViewNum
c.execute(f'UPDATE userodapptview SET ApptViewNum = {all_view_c2} WHERE ClinicNum = 2')
print(f'Clinic 2 ApptViewNum corrected: {c.rowcount} rows')

conn.commit()

# Final verification
print('\n=== FINAL STATE ===')
c.execute('SELECT ClinicNum, ApptViewNum, Description FROM apptview ORDER BY ClinicNum, ApptViewNum')
for r in c.fetchall():
    print(f'  ClinicNum={r["ClinicNum"]} ApptViewNum={r["ApptViewNum"]} {r["Description"]}')

c.execute('SELECT ClinicNum, COUNT(*) as cnt, ApptViewNum FROM userodapptview GROUP BY ClinicNum, ApptViewNum')
for r in c.fetchall():
    print(f'  userodapptview ClinicNum={r["ClinicNum"]}: {r["cnt"]} users, ApptViewNum={r["ApptViewNum"]}')

c.execute('SELECT ApptViewNum, COUNT(*) as cnt FROM apptviewitem GROUP BY ApptViewNum ORDER BY ApptViewNum')
for r in c.fetchall():
    print(f'  apptviewitem ApptViewNum={r["ApptViewNum"]}: {r["cnt"]} items')

conn.close()
print('\nDONE. Restart Helianz.')

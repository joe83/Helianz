import mysql.connector
conn = mysql.connector.connect(host='localhost', user='root', password='J0k0m4r0k3@', database='helianz')
c = conn.cursor(dictionary=True)

c.execute('SELECT Category, COUNT(*) as cnt, MIN(DefNum) as mn, MAX(DefNum) as mx FROM definition GROUP BY Category ORDER BY Category')
rows = c.fetchall()
for r in rows:
    print(f"Cat {r['Category']}: {r['cnt']} items, DefNum {r['mn']}-{r['mx']}")

# Show sample from key categories
for cat in [1,2,3,4,5,6,9,10,15,16,17,18,19,20,21,22,23,24,25]:
    c.execute(f'SELECT DefNum, ItemName, ItemValue, ItemColor FROM definition WHERE Category={cat} LIMIT 5')
    rows = c.fetchall()
    if rows:
        print(f"\n--- Category {cat} ---")
        for r in rows:
            print(f"  DefNum={r['DefNum']}: {r['ItemName']} | Value={r['ItemValue']} | Color={r['ItemColor']}")

conn.close()

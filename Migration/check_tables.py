import mysql.connector

conn = mysql.connector.connect(host='localhost', user='root', password='J0k0m4r0k3@')

for db in ['helianz_klaten', 'helianz_boyolali']:
    c = conn.cursor()
    c.execute(f"USE {db}")
    c.execute("""
        SELECT TABLE_NAME, TABLE_ROWS, AUTO_INCREMENT,
               ROUND(DATA_LENGTH/1048576, 1) as MB
        FROM information_schema.TABLES
        WHERE TABLE_SCHEMA = %s AND TABLE_NAME NOT LIKE '%archive%'
        ORDER BY DATA_LENGTH DESC LIMIT 20
    """, (db,))
    
    print(f"\n{'='*60}")
    print(f"  {db}")
    print(f"{'='*60}")
    print(f"{'Table':<30} {'Rows':>10} {'AutoInc':>12} {'MB':>8}")
    print('-' * 62)
    for row in c.fetchall():
        print(f"{row[0]:<30} {row[1] or 0:>10,} {row[2] or 0:>12,} {row[3]:>8}")
    c.close()

conn.close()

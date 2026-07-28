"""Identify all log/audit tables and their sizes."""
import mysql.connector

conn = mysql.connector.connect(host='localhost', user='root', password='J0k0m4r0k3@')

LOG_PATTERNS = ['%log%', '%audit%', '%signal%', '%deleted%', '%entrylog%']

for db in ['helianz_klaten', 'helianz_boyolali']:
    c = conn.cursor()
    c.execute(f"USE {db}")
    
    print(f"\n{'='*60}")
    print(f"  {db}")
    print(f"{'='*60}")
    print(f"{'Table':<35} {'Rows':>10} {'Max PK':>12}")
    print('-' * 60)
    
    for pattern in LOG_PATTERNS:
        c.execute(f"""
            SELECT TABLE_NAME FROM information_schema.TABLES 
            WHERE TABLE_SCHEMA = '{db}' AND TABLE_NAME LIKE '{pattern}'
              AND TABLE_NAME NOT LIKE '%archive%'
            ORDER BY TABLE_NAME
        """)
        for (tbl,) in c.fetchall():
            # Get row count and max PK
            c.execute(f"SELECT COUNT(*) FROM `{tbl}`")
            rows = c.fetchone()[0]
            # Try to find PK
            c.execute(f"""
                SELECT COLUMN_NAME FROM information_schema.COLUMNS
                WHERE TABLE_SCHEMA='{db}' AND TABLE_NAME='{tbl}'
                AND EXTRA LIKE '%auto_increment%'
            """)
            pk_row = c.fetchone()
            if pk_row:
                c.execute(f"SELECT MAX(`{pk_row[0]}`) FROM `{tbl}`")
                max_pk = c.fetchone()[0] or 0
                print(f"  {tbl:<35} {rows:>10,} {max_pk:>12,}")
            else:
                print(f"  {tbl:<35} {rows:>10,} {'(no AI)':>12}")
    
    c.close()

conn.close()

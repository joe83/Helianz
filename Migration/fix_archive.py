"""Remove auto_increment from securitylog_archive tables so they don't affect offset calc."""
import mysql.connector

HOST = "localhost"
USER = "root"
PASSWORD = "J0k0m4r0k3@"

for db in ["helianz_klaten", "helianz_boyolali"]:
    conn = mysql.connector.connect(host=HOST, user=USER, password=PASSWORD, database=db)
    c = conn.cursor()

    # Check current state
    c.execute("""
        SELECT TABLE_NAME, EXTRA FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = %s AND COLUMN_NAME = 'SecurityLogNum'
    """, (db,))
    for row in c.fetchall():
        print(f"{db}: {row[0]} EXTRA={row[1]}")

    # Fix archive table
    c.execute("ALTER TABLE securitylog_archive MODIFY SecurityLogNum bigint(20) NOT NULL")
    print(f"  -> removed auto_increment from securitylog_archive")

    # Verify
    c.execute("SELECT MAX(SecurityLogNum) FROM securitylog")
    print(f"  -> active securitylog max: {c.fetchone()[0]}")

    conn.commit()
    c.close()
    conn.close()

print("\nDone.")

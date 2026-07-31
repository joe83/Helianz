"""
Setup admin and service users after Helianz migration.
Generates proper SHA3-512 password hashes matching the app's authentication.

USAGE:
  python setup_users.py [--host HOST] [--user USER] [--password PASS] [--database DB]
"""
import mysql.connector
import hashlib
import base64
import os
import sys

# -- Config -------------------------------------------------------
DB_HOST = 'localhost'
DB_USER = 'root'
DB_PASS = 'J0k0m4r0k3@'
DB_NAME = 'helianz_klt'

FIXED_PASSWORD = '12345'

args = sys.argv[1:]
i = 0
while i < len(args):
    if args[i] == '--host' and i + 1 < len(args):
        DB_HOST = args[i + 1]; i += 1
    elif args[i] == '--user' and i + 1 < len(args):
        DB_USER = args[i + 1]; i += 1
    elif args[i] == '--password' and i + 1 < len(args):
        DB_PASS = args[i + 1]; i += 1
    elif args[i] == '--database' and i + 1 < len(args):
        DB_NAME = args[i + 1]; i += 1
    i += 1


def generate_sha512_hash(password):
    """Generate SHA3-512 password hash matching Helianz Authentication format.
    Format: SHA3_512$<base64_salt>$<base64_hash>
    where hash = base64(sha3_512(UTF16LE(salt + password)))
    """
    # 64 bytes random salt (same as C# GenerateSalt for SHA3_512)
    salt_bytes = os.urandom(64)
    salt_b64 = base64.b64encode(salt_bytes).decode('ascii')

    # C# Encoding.Unicode = UTF-16LE
    combined = (salt_b64 + password).encode('utf-16-le')
    hash_bytes = hashlib.sha3_512(combined).digest()
    hash_b64 = base64.b64encode(hash_bytes).decode('ascii')

    return f"SHA3_512${salt_b64}${hash_b64}"


def main():
    print("=" * 60)
    print("  Helianz User Setup (Post-Migration)")
    print(f"  DB: {DB_HOST}/{DB_NAME}")
    print("=" * 60)
    print()

    print("  [1/4] Generating password hash for '12345'...")
    pw_hash = generate_sha512_hash(FIXED_PASSWORD)
    print(f"  Hash generated (SHA3_512).")
    print()

    print("  [2/4] Connecting to database...")
    conn = mysql.connector.connect(
        host=DB_HOST, user=DB_USER, password=DB_PASS, database=DB_NAME,
        use_pure=True,
    )
    print("  Connected.")
    c = conn.cursor(buffered=True, dictionary=True)

    # -- Step 1: Ensure MT_Service group exists --------------------
    print()
    print("  [3/4] Ensuring groups exist...")

    # Check if MT_Service group exists (use group 13 to avoid conflicts with 1-12)
    c.execute("SELECT UserGroupNum FROM usergroup WHERE UserGroupNum = 13")
    if not c.fetchone():
        c.execute("INSERT INTO usergroup (UserGroupNum, Description) VALUES (13, 'MT_Service')")
        print("  Created group: MT_Service (13)")
    else:
        print("  Group MT_Service (13) already exists.")

    # Grant "choose database" permission to MT_Service group
    # PermType 44 = Image Delete / Manage module access; we need to find the right perm.
    # For Middle Tier, the key is just having the user in a recognized group.
    # PermType 8 = Setup (global) gives basic access.
    c.execute("""
        INSERT IGNORE INTO grouppermission (UserGroupNum, PermType, FKey, NewerDate, NewerDays)
        VALUES (13, 22, 0, '0001-01-01', 0)
    """)
    print("  Added basic permission to MT_Service group.")
    conn.commit()

    # -- Step 2: Create Admin user --------------------------------
    print()
    print("  [4/4] Creating users...")

    # Admin user - check if exists
    c.execute("SELECT UserNum FROM userod WHERE UserName = 'Admin'")
    admin = c.fetchone()
    if admin:
        c.execute("UPDATE userod SET Password = %s, PasswordIsStrong = 1, IsHidden = 0 WHERE UserName = 'Admin'",
                   (pw_hash,))
        print("  Updated existing user: Admin (password reset to 12345)")
        # Ensure Admin is in group 1
        c.execute("SELECT UserNum FROM userod WHERE UserName = 'Admin'")
        admin_num = c.fetchone()['UserNum']
    else:
        c.execute("SELECT COALESCE(MAX(UserNum), 0) + 1 FROM userod")
        new_num = c.fetchone()['COALESCE(MAX(UserNum), 0) + 1']
        c.execute("""
            INSERT INTO userod (UserNum, UserName, Password, UserGroupNum, IsHidden, PasswordIsStrong)
            VALUES (%s, 'Admin', %s, 1, 0, 1)
        """, (new_num, pw_hash))
        admin_num = new_num
        print(f"  Created user: Admin (UserNum={admin_num}, password=12345)")

    # Attach Admin to group 1 (Admin)
    c.execute("""
        INSERT IGNORE INTO usergroupattach (UserNum, UserGroupNum)
        VALUES (%s, 1)
    """, (admin_num,))
    print("  Admin assigned to group: 1 (Admin)")

    # -- Step 3: Create helianz service user ----------------------
    c.execute("SELECT UserNum FROM userod WHERE UserName = 'helianz'")
    helianz = c.fetchone()
    if helianz:
        c.execute("UPDATE userod SET Password = %s, PasswordIsStrong = 1, IsHidden = 0 WHERE UserName = 'helianz'",
                   (pw_hash,))
        print("  Updated existing user: helianz (password reset to 12345)")
        c.execute("SELECT UserNum FROM userod WHERE UserName = 'helianz'")
        helianz_num = c.fetchone()['UserNum']
    else:
        c.execute("SELECT COALESCE(MAX(UserNum), 0) + 1 FROM userod")
        new_num = c.fetchone()['COALESCE(MAX(UserNum), 0) + 1']
        c.execute("""
            INSERT INTO userod (UserNum, UserName, Password, UserGroupNum, IsHidden, PasswordIsStrong)
            VALUES (%s, 'helianz', %s, 13, 0, 1)
        """, (new_num, pw_hash))
        helianz_num = new_num
        print(f"  Created user: helianz (UserNum={helianz_num}, password=12345)")

    # Attach helianz to MT_Service group
    c.execute("""
        INSERT IGNORE INTO usergroupattach (UserNum, UserGroupNum)
        VALUES (%s, 13)
    """, (helianz_num,))
    print("  helianz assigned to group: 13 (MT_Service)")

    conn.commit()

    # -- Summary ---------------------------------------------------
    print()
    print("=" * 60)
    print("  SETUP COMPLETE")
    print("=" * 60)
    print(f"  Admin   : password = 12345, group = Admin (1), full perms")
    print(f"  helianz : password = 12345, group = MT_Service (13)")
    print("=" * 60)

    conn.close()


if __name__ == '__main__':
    try:
        main()
    except Exception as e:
        print(f"\n  ERROR: {e}")
        import traceback
        traceback.print_exc()
    finally:
        input("\nPress Enter to exit...")

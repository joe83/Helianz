import pymysql

def run():
    conn = pymysql.connect(host='127.0.0.1', user='root', password='J0k0m4r0k3@', autocommit=True)
    with conn.cursor() as cur:
        for db in ['helianz', 'helianz_klt', 'helianz_byl', 'helianz_jog', 'demo']:
            try:
                cur.execute(f'USE `{db}`')
                cur.execute('SHOW COLUMNS FROM `userod` LIKE %s', ('Email',))
                if not cur.fetchall():
                    print(f'Adding Email column to {db}.userod...')
                    cur.execute("ALTER TABLE `userod` ADD COLUMN `Email` VARCHAR(255) NOT NULL DEFAULT '' AFTER `UserName`")
                    cur.execute("ALTER TABLE `userod` ADD INDEX `idx_userod_email` (`Email`)")
                    print(f'Successfully added Email column to {db}.userod')
                else:
                    print(f'{db}.userod already has Email column')
            except Exception as ex:
                print(f'Skipping {db}: {ex}')

if __name__ == '__main__':
    run()

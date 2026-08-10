#!/usr/bin/env python3
import pymysql, traceback
my = pymysql.connect(host='127.0.0.1',port=3306,user='root',password='F334uo+fIDeBJ2CBna8yMeu+hl5JTMXA',database='helianz_klt')
c = my.cursor()
c.execute('SHOW COLUMNS FROM account')
for col in c.fetchall():
    name, mt = col[0], col[1].upper()
    is_tiny = mt.startswith('TINYINT(1)') or mt == 'TINYINT'
    is_int = any(mt.startswith(t) for t in ('INT','SMALLINT','MEDIUMINT','BIGINT','BIT'))
    is_float = any(mt.startswith(t) for t in ('DECIMAL','FLOAT','DOUBLE'))
    print(f'{name:30s} {mt:20s} tiny={is_tiny} int={is_int} float={is_float}')

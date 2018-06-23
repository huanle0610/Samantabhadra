#!/usr/bin/python2
# -*- coding: UTF-8 -*-
import MySQLdb
import sys


def insert(table, myDict):
    # 打开数据库连接
    db = MySQLdb.connect(host="127.0.0.1", user="root", passwd="amtf", db="amtf", port=3306, charset="utf8")

    # 使用cursor()方法获取操作游标
    cursor = db.cursor()

    # SQL 插入语句
    sql = get_insert_sql(table, myDict)
    try:
        print sql
        # 执行sql语句
        cursor.execute(sql, myDict.values())
        # 提交到数据库执行
        db.commit()
    except:
        type, value, traceback = sys.exc_info()
        # Rollback in case there is any error
        db.rollback()

    # 关闭数据库连接
    db.close()


def get_insert_sql(table, myDict):
    placeholders = ', '.join(['%s'] * len(myDict))
    columns = ', '.join(myDict.keys())
    return "INSERT INTO %s ( %s ) VALUES ( %s )" % (table, columns, placeholders)


if __name__ == '__main__':
    print insert('article', {
        "article_title": 'abc',
        "article_content": 'abc',
        "article_cat": 'abc'
    })

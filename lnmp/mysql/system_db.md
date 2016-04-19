### information_schema
information_schema数据库是MySQL自带的.

它提供了访问数据库元数据的途径。

#### 元数据
元数据是关于数据的数据，如数据库名或表名，列的数据类型，或访问权限等。

```html
MariaDB [f1]> SELECT table_name, table_type, engine FROM information_schema.tables WHERE table_schema = 'f1' ORDER BY table_name DESC;
+---------------------------+------------+--------+
| table_name                | table_type | engine |
+---------------------------+------------+--------+
| am_withdraw               | BASE TABLE | InnoDB |
| am_user_group             | BASE TABLE | InnoDB |
| am_user                   | BASE TABLE | InnoDB |
| am_ticket                 | BASE TABLE | InnoDB |
| am_takeself               | BASE TABLE | InnoDB |
| am_suggestion             | BASE TABLE | InnoDB |
| am_spec_photo             | BASE TABLE | InnoDB |
+---------------------------+------------+--------+
7 rows in set (0.01 sec)

# 字段名不区分大小写
MariaDB [f1]> SELECT table_name, column_name, COLUMN_NAME, data_type  FROM information_schema.columns WHERE table_schema = 'f1' and table_name = 'am_ticket' ORDER BY table_name DESC;
+------------+-------------+-------------+-----------+
| table_name | column_name | COLUMN_NAME | data_type |
+------------+-------------+-------------+-----------+
| am_ticket  | id          | id          | int       |
| am_ticket  | name        | name        | varchar   |
| am_ticket  | value       | value       | decimal   |
| am_ticket  | start_time  | start_time  | datetime  |
| am_ticket  | end_time    | end_time    | datetime  |
| am_ticket  | point       | point       | smallint  |
+------------+-------------+-------------+-----------+
6 rows in set (0.00 sec)

```

每个用户都可以访问这个数据库，但是只能看到有权限的相关内容。.


### mysql
系统库

包含了：

- 权限表
- 时区表
- 用户表
- 进程表
- 日志表
- ...

[system-database官方说明](https://dev.mysql.com/doc/refman/5.7/en/system-database.html)
[information_schema官方说明](https://dev.mysql.com/doc/refman/5.7/en/information-schema.html)

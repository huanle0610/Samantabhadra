# SQL
## 六部分
 
1. DDL （Data Definition Language） 数据定义语言

    CREATE, ALTER and DROP 创建数据库、数据表；修改数据表；删除数据表

2. DML （Data Manipulation Language） 数据操纵语言

    INSERT, UPDATE and DELETE 插入、更新、删除数据行

3. DQL （Data Query Language） 数据查询语言

    SELECT, SHOW and HELP 查询数据

4. DCL （Data Control Language） 数据控制语言

    GRANT and REVOKE 权限管理

5. DTL （Data Transaction Language)

    START TRANSACTION, SAVEPOINT, COMMIT and ROLLBACK [TO SAVEPOINT] 事务相关操作
    

对MySQL, **数据库名和数据表名区分大小写**，其他如字段名、关键字等不区分大小写。

### 数据定义


```html
CREATE DATABASE sm_app;

CREATE TABLE `sm_right` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL COMMENT '权限名字',
  `right` text COMMENT '权限码(控制器+动作)',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除状态 1删除,0正常',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='权限资源码';

DROP TABLE `sm_right`;
```


### 数据操纵
```html
INSERT INTO `f1`.`sm_right` (`id`, `name`, `right`, `is_del`) VALUES (default, "AddGoods", "Goods/AddGoodsAction", 0);
```


### 数据查询语言

```html
select * from `f1`.`sm_right`;
```

### 数据控制语言

```html
GRANT ALL ON f1.* TO xm@localhost IDENTIFIED BY 'password_of_xm';

GRANT SELECT,UPDATE ON f1.* TO xm@localhost IDENTIFIED BY 'password_of_xm';
```

### DTL
请自行了解


## 通过SQL理解数据库

```html
MariaDB [(none)]> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |  
| f1                 |
| site_cms           |
| mysql              |
+--------------------+
5 rows in set (0.03 sec)
```

## [系统库](system_db.md)

```html
MariaDB [(none)]> use f1
MariaDB [f1]> show tables;
+---------------------------+
| Tables_in_f1              |
+---------------------------+
| am_account_log            |
| am_ad_manage              |
| am_ad_position            |
| am_address                |
| am_admin                  |
| am_user_group             |
| am_withdraw               |
+---------------------------+
7 rows in set (0.00 sec)
```


## [常用语句](sql_statement.pdf)

## [cookbook note](cookbook_note.md)

## [时间函数](function_date.md)

## [字符串函数](function_str.md)

## 官方演示库
[下载sakila-db](sakila-db.zip)
1. 解压
2. 参考readme： 导入 sakila-db; 安装mysql-workbench
3. 练习查询
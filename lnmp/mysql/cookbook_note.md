## cookbook note

MySQL简介

    MySQL 数据库系统使用以mysqld服务器为中心的c/s架构。
    
    服务器是事实上的操作数据库的程序。
    
    客户端程序并不直接操作数据库。
    
    相反，它们使用SQL语句来向服务器传达你的意图。
    
    客户端程序被安装在你想访问MySQL的本地机器上。
    
    但服务器可以安装在任何地方，只要客户端能连接上。
    
    MySQL生来就是网络数据库系统，所以客户端能够运行在本机或任何其他机器(也许是在星球的另一端的某台机器上)上与服务器进行通信。
    
    可是因为多个不同目的而写出的一些客户端，但是每个客户端和服务器的交互都是先连接到服务器，发送SQL语句到服务器来执行数据库操作；然后从服务器接收执行结果。

```html
建立MySQL的用户
    mysql -h localhost -p -uroot
    grant all on cookbook.* to 'cbuser'@'localhost' identified by 'hl';

创建数据库与数据表
    create database if not exists cookbook;
    use cookbook;
    create table limbs(thing varchar(20), legs int, arms int) ENGINE=InnoDB DEFAULT CHARSET=utf8;
    insert into limbs(thing,legs,arms) values
    ('human',2,2),('insect',6,0),('sqid',0, 10),('octopus',0,8),('fish',0,0),('entipede',100,0),('table',4,0),('armchair',4,2),('phonograph',0,1),('tripod',3,0),('Peg Leg Pete',1,2),('space alien',NULL,NULL);
    
MySQL的关闭
    mysqladmin -p -uroot shutdown

在MySQL中localhost的意义
    当连接到MySQL服务器时，你所指定的参数之一就是服务器正在运行于其上的主机。大多数程序将主机名localhost和ip地址127.0.0.1视为‘本地机器‘的同义词。但是在unix下，MySQL程序表现出了不同：依照惯例，它们特殊对待主机名localhost，这时它们会尝试使用一个unix domain socket文件来连接本地服务器。其强制使用tcp/ip连接到本地服务器，那就使用ip地址127.0.0.1而不是主机名localhost.可选的，也可以通过指定--protocol=tcp选项来强制使用tcp/ip进行连接。
    tcp/ip连接的默认端口是3306。unix domain socket的路径名是常常变化，尽管通常情况为/tmp/mysql.sock.为显式的指定套接字文件可以用选项 -S filename   或者  --socket = file_name

查看mysql程序从选项文件中读取了哪些选项，使用命令
    mysql --print-defaults

查看mysql默认配置信息
    my_print_defaults
        Default options are read from the following files in the given order:
        C:\WINDOWS\my.ini C:\WINDOWS\my.cnf C:\my.ini C:\my.cnf C:\Program Files\MySQL\M
        ySQL Server 5.1\my.ini C:\Program Files\MySQL\MySQL Server 5.1\my.cnf
        
保护选项配置文件
    chmod 600 .my.cnf
    chmod go-rwx .my.cnf
    两者相等的。
    在windows你能使用windows资源管理器来设置文件权限。

发起SQL语句
    select now();
    select now()\g
    select now()\G

取消一条部分输入的语句
    mysql> select a\c
    mysql>
    也可以使用行删除符：unix/linux,Ctrl-U ;windows, Esc

从文件中读取语句
    重定向输入或者使用source
    mysql cookbook< filename
    source abc.sql

从其它程序读取语句
    使用管道
    mysql cookbook<limbs.sql
    等价
    cat limbs.sql | mysql cookbook

    mysqldump cookbook | mysql -h some.other.host.com cookbook
    
一行输入所有的sql
    >mysql -ucbuser -p -e "select now();" cookbook
    Enter password: **
    +---------------------+
    | now()               |
    +---------------------+
    | 2012-03-10 10:08:48 |
    +---------------------+
    >mysql -ucbuser -p -e "select now()\G" cookbook
    *************************** 1. row ***************************
    now(): 2012-03-10 10:10:17
    
预防查询输出超出屏幕范围
    mysql -uroot -p --pager=/usr/bin/less
    让mysql使用你的默认分页工具，它由PAGER环境变量设定

发送查询输出到文件或程序
    重定向输出或者使用管道
    echo "select * from limbs" | mysql cookbook
    mysql cookbook < inputfile > outputfile
    mysql cookbook < inputfile | mail paul
    mysql -uroot -p --pager
   
    在一个mysql会话中，你可以使用\P或\n来开启或关闭分页功能。
    mysql> \P
    mysql> \P /usr/bin/less
    mysql> \n

选择表格和制表符定界的查询输出格式
    当你获得制表定界的输出时，mysql却生成表格，或者相反。
    使用-t (或者--table)生成更具可读性的表格输出。
    mysql -t cookbook < inputfile | lpr
    mysql -t cookbook < inputfile | mail lee

结果以html或xml返回
    -H --html
    -X --xml
    选项仅供生成结果集的语句产生输出。
    >mysql -ucbuser -p -H -e "select now()\G" cookbo
    ok
    Enter password: **
    <TABLE BORDER=1><TR><TH>now()</TH></TR><TR><TD>2012-03-10 10:32:35</TD></TR></TA
BLE>

在查询输出中禁止列的头部
    --skip-column-names 
    -ss
    等价
    mysql -ss -e "select arms from limbs" cookbook | summarize 

控制mysql的繁冗级别
    C:\Documents and Settings\huanle>mysql -ucbuser  -v  -p -e "show tables;select *
     from limbs where legs=2;" cookbook
    Enter password: **
    --------------
    show tables
    --------------

    +--------------------+
    | Tables_in_cookbook |
    +--------------------+
    | adcount            |
    | limbs              |
    +--------------------+
    --------------
    select * from limbs where legs=2
    --------------

    +-------+------+------+
    | thing | legs | arms |
    +-------+------+------+
    | human |    2 |    2 |
    | human |    2 |    2 |
    +-------+------+------+

记录交互式的mysql会话
    你想保留在mysql会话所做事情的记录。
    创建一个tee文件。
    mysql --tee=e:\mysql.out.txt cookbook
    要在mysql里控制记录会话与否，可分别使用\T和\t来开启或关闭tee的输出。如果只想记录会话的某个部分这就很有用。
    mysql> \t
    Outfile disabled.
    mysql> \T
    Logging to file 'e:\mysql.out.txt'
    mysql>
    
以之前执行的语句创建mysql脚本
    两个信息来源：
    通过mysql中使用--tee命令选项或者\T命令你可以记录mysql会话的所有或部分。
    在unix下，第二个选项是你的历史文件。mysql维护一份你语句的记录，保存在你的home目录的.mysql_history文件里。

在sql语句中使用用户自定义的变量
    select @last_id := last_insert_id();
    set @sum = 9+3;
    select @name := thing from limbs where legs < 0;
    mysql> select legs from limbs where arms =0  limit 1 into @leg0;
    Query OK, 1 row affected (0.00 sec)

    mysql> select @leg0;
    +-------+
    | @leg0 |
    +-------+
    |     6 |
    +-------+
    1 row in set (0.00 sec)

为查询输出行计数
    mysql -ss -e "select things,arms from limbs" cookbook | cat -n
    
    mysql> set @n = 0;
    Query OK, 0 rows affected (0.00 sec)
    mysql> select @n := @n+1 as rownum, thing, arms, legs from limbs;
    mysql> select @n;
    +------+
    | @n   |
    +------+
    |   24 |
    +------+
    1 row in set (0.00 sec)

    
计算器 
    set @daily_room_charge = 100.00;
    set @num_of_nights = 3;
    set @tax_percent = 8;
    set @total_room_charge = @daily_room_charge * @num_of_nights;
    set @tax = (@total_room_charge * @tax_percent)/100;
    set @total = @total_room_charge + @tax;
    select @total;
    324

在Unix下编写shell脚本

#!/bin/sh
# mysql_uptime.sh -以秒数来报告服务器的正常运行时间

/usr/local/mysql/bin/mysql --skip-column-names -B -e "show /*!50002 GLOBAL */ STATUS LIKE 'Uptime'" 


获取当前服务器的状态
mysql> stauts

--------------
/usr/local/mysql/bin/mysql  Ver 14.14 Distrib 5.1.55, for pc-linux-gnu (i686) using  EditLine wrapper

Connection id:		5
Current database:	
Current user:		huanle0610@localhost
SSL:			Not in use
Current pager:		stdout
Using outfile:		''
Using delimiter:	;
Server version:		5.1.55 Source distribution
Protocol version:	10
Connection:		Localhost via UNIX socket
Server characterset:	utf8
Db     characterset:	utf8
Client characterset:	utf8
Conn.  characterset:	utf8
UNIX socket:		/tmp/mysql.sock
Uptime:			26 min 33 sec

Threads: 2  Questions: 16  Slow queries: 0  Opens: 17  Flush tables: 1  Open tables: 4  Queries per second avg: 0.10
--------------

read !/usr/local/mysql/bin/mysql -e 'status' | grep -i 'uptime'
Uptime:			29 min 4 sec

SQL语句可以分为两大类：
1.不返回结果集的语句。包括insert, delete, update.作为一个通用规则，这类语句通常以某种方式改变了数据库。也有一些例外，譬如　use db,它改变了你会话默认的数据库而不改变数据库本身。
２. 返回结果集的语句，例如select,show,explain,describe.通常这些语句我是指select语句，但是你理解所有这类语句。

*/
永恒的查询
select job as '工作',monthly as '月薪' from test where '月薪' > 8; #不能在where中使用别名,
# 因为where子句在select子句之前处理
#获取月薪大于8的行，别名的使用。
#这里用到了子查询
select * from (select id,job as '工作',monthly as '月薪',date from test) x where `月薪` > 8;
#查询每个职位的最高月薪记录行，应该有几个职位结果集就有几行.
select * from test as t where monthly = (select max(b.monthly) from test as b where b.job = t.job);
mysql> select * from test;
+----+-----------+---------+------------+
| id | job       | monthly | date       |
+----+-----------+---------+------------+
|  1 | sales     |       4 | 2012-03-11 |
|  2 | sales     |       8 | 2012-03-11 |
|  3 | programer |       7 | 2012-03-11 |
|  4 | programer |       9 | 2012-03-11 |
+----+-----------+---------+------------+
4 rows in set (0.39 sec)

mysql> select * from test a where monthly=(select max(b.monthly) from test b whe
re b.job=a.job);
+----+-----------+---------+------------+
| id | job       | monthly | date       |
+----+-----------+---------+------------+
|  2 | sales     |       8 | 2012-03-11 |
|  4 | programer |       9 | 2012-03-11 |
+----+-----------+---------+------------+
2 rows in set (0.06 sec)


SQL COOKBOOK
查找部门10中所有员工，所有得到提成的员工，以及部门20中工资不超过2000美金的员工。
mysql> select * from emp where deptno=10
    -> or comm is not null
    -> or sal<= 2000 and deptno=20;
+-------+--------+-----------+------+------------+------+------+--------+
| empno | ename  | job       | mgr  | hiredate   | sal  | comm | deptno |
+-------+--------+-----------+------+------------+------+------+--------+
|     1 | SMITH  | CLERK     | 7902 | 1980-12-17 |  800 | NULL |     20 |
|     2 | ALLEN  | SALESMAN  | 7698 | 1981-02-20 | 1600 |  300 |     30 |
|     3 | WARD   | SALESMAN  | 7698 | 1981-02-22 | 1250 |  500 |     30 |
|     7 | CLARK  | MANGER    | 7839 | 1981-06-09 | 2450 | NULL |     10 |
|     9 | KING   | PRESIDENT | NULL | 1981-11-17 | 5000 | NULL |     10 |
|    10 | TURNER | SALESMAN  | 7698 | 1981-09-08 | 1500 |    0 |     30 |
|    11 | ADAMS  | CLERK     | 7788 | 1983-12-12 | 1100 | NULL |     20 |
|    14 | MILLER | CLERK     | 7782 | 1982-01-23 | 1300 | NULL |     10 |
+-------+--------+-----------+------+------------+------+------+--------+
8 rows in set (0.08 sec)

别名
mysql> select ename as '姓名',sal as '销售额',comm as '提成' from emp where sal<
5000;
+--------+--------+------+
| 姓名       | 销售额      | 提成     |
+--------+--------+------+
| SMITH  |    800 | NULL |
| ALLEN  |   1600 |  300 |
| WARD   |   1250 |  500 |
| JONES  |   2975 | NULL |
| MARTIN |   1250 | NULL |
| BLAKE  |   2850 | NULL |
| CLARK  |   2450 | NULL |
| SCORT  |   3000 | NULL |
| TURNER |   1500 |    0 |
| ADAMS  |   1100 | NULL |
| JAMES  |    950 | NULL |
| FORD   |   3000 | NULL |
| MILLER |   1300 | NULL |
+--------+--------+------+
13 rows in set (0.06 sec)

连接列值
mysql> select concat(ename, ' WORKS AS A ', job) as msg from emp where deptno=10
;
+---------------------------+
| msg                       |
+---------------------------+
| CLARK WORKS AS A MANGER   |
| KING WORKS AS A PRESIDENT |
| MILLER WORKS AS A CLERK   |
+---------------------------+
3 rows in set (0.00 sec)

条件的使用
mysql> select if(1<2,'yes','no');
+--------------------+
| if(1<2,'yes','no') |
+--------------------+
| yes                |
+--------------------+
1 row in set (0.00 sec)
在select中使用条件逻辑，case
 select ename,sal,
 case
 when sal<=2000 then 'UNDERPAID'
 when sal>= 4000 then 'OVERPAID'
 else 'OK'
 end  as status
 from emp;
+--------+------+-----------+
| ename  | sal  | status    |
+--------+------+-----------+
| SMITH  |  800 | UNDERPAID |
| ALLEN  | 1600 | UNDERPAID |
| WARD   | 1250 | UNDERPAID |
| JONES  | 2975 | OK        |
| MARTIN | 1250 | UNDERPAID |
| BLAKE  | 2850 | OK        |
| CLARK  | 2450 | OK        |
| SCORT  | 3000 | OK        |
| KING   | 5000 | OVERPAID  |
| TURNER | 1500 | UNDERPAID |
| ADAMS  | 1100 | UNDERPAID |
| JAMES  |  950 | UNDERPAID |
| FORD   | 3000 | OK        |
| MILLER | 1300 | UNDERPAID |
+--------+------+-----------+
14 rows in set (0.06 sec)

随机取n条数据
mysql> select ename,job from emp order by rand() limit 5;
+-------+-----------+
| ename | job       |
+-------+-----------+
| KING  | PRESIDENT |
| JAMES | CLERK     |
| SMITH | CLERK     |
| WARD  | SALESMAN  |
| ADAMS | CLERK     |
+-------+-----------+
5 rows in set (0.00 sec)

查找空值
mysql> select * from emp where comm is NULL;
+-------+--------+-----------+------+------------+------+------+--------+
| empno | ename  | job       | mgr  | hiredate   | sal  | comm | deptno |
+-------+--------+-----------+------+------------+------+------+--------+
|     1 | SMITH  | CLERK     | 7902 | 1980-12-17 |  800 | NULL |     20 |
|     4 | JONES  | MANGER    | 7839 | 1981-04-02 | 2975 | NULL |     20 |
|     5 | MARTIN | SALESMAN  | 7698 | 1980-09-28 | 1250 | NULL |     30 |
|     6 | BLAKE  | MANGER    | 7839 | 1981-05-01 | 2850 | NULL |     30 |
|     7 | CLARK  | MANGER    | 7839 | 1981-06-09 | 2450 | NULL |     10 |
|     8 | SCORT  | ANALYST   | 7566 | 1982-12-09 | 3000 | NULL |     20 |
|     9 | KING   | PRESIDENT | NULL | 1981-11-17 | 5000 | NULL |     10 |
|    11 | ADAMS  | CLERK     | 7788 | 1983-12-12 | 1100 | NULL |     20 |
|    12 | JAMES  | CLERK     | 7698 | 1981-12-03 |  950 | NULL |     30 |
|    13 | FORD   | ANALYST   | 7566 | 1981-12-03 | 3000 | NULL |     20 |
|    14 | MILLER | CLERK     | 7782 | 1982-01-23 | 1300 | NULL |     10 |
+-------+--------+-----------+------+------------+------+------+--------+

转换空值，使用到函数coalesce
mysql> select empno,ename,sal,coalesce(comm,'没压力') as comm from emp;
+-------+--------+------+--------+
| empno | ename  | sal  | comm   |
+-------+--------+------+--------+
|     1 | SMITH  |  800 | 没压力     |
|     2 | ALLEN  | 1600 | 300    |
|     3 | WARD   | 1250 | 500    |
|     4 | JONES  | 2975 | 没压力     |
|     5 | MARTIN | 1250 | 没压力     |
|     6 | BLAKE  | 2850 | 没压力     |
|     7 | CLARK  | 2450 | 没压力     |
|     8 | SCORT  | 3000 | 没压力     |
|     9 | KING   | 5000 | 没压力     |
|    10 | TURNER | 1500 | 0      |
|    11 | ADAMS  | 1100 | 没压力     |
|    12 | JAMES  |  950 | 没压力     |
|    13 | FORD   | 3000 | 没压力     |
|    14 | MILLER | 1300 | 没压力     |
+-------+--------+------+--------+
14 rows in set (0.00 sec)

查找一个范围
mysql> select empno,ename,job from emp where deptno in  (10,20);
+-------+--------+-----------+
| empno | ename  | job       |
+-------+--------+-----------+
|     1 | SMITH  | CLERK     |
|     4 | JONES  | MANGER    |
|     7 | CLARK  | MANGER    |
|     8 | SCORT  | ANALYST   |
|     9 | KING   | PRESIDENT |
|    11 | ADAMS  | CLERK     |
|    13 | FORD   | ANALYST   |
|    14 | MILLER | CLERK     |
+-------+--------+-----------+
8 rows in set (0.02 sec)

模式搜索
mysql> select empno,ename,job,deptno from emp where deptno in  (10,20)
    -> and (ename like '%I%' or job like '%ER');
+-------+--------+-----------+--------+
| empno | ename  | job       | deptno |
+-------+--------+-----------+--------+
|     1 | SMITH  | CLERK     |     20 |
|     4 | JONES  | MANGER    |     20 |
|     7 | CLARK  | MANGER    |     10 |
|     9 | KING   | PRESIDENT |     10 |
|    14 | MILLER | CLERK     |     10 |
+-------+--------+-----------+--------+
5 rows in set (0.00 sec)

排序
显示部门10中的员工名字，职位，工资，并按照工资的升序排列
mysql> select ename,job,sal
    -> from emp
    -> where deptno = 10
    -> order by sal asc;
+--------+-----------+------+
| ename  | job       | sal  |
+--------+-----------+------+
| MILLER | CLERK     | 1300 |
| CLARK  | MANGER    | 2450 |
| KING   | PRESIDENT | 5000 |
+--------+-----------+------+
3 rows in set (0.02 sec)

多字段排序，部门升序，工资降序
order by 优先顺序从左到右
mysql> select empno,deptno,sal,ename,job from emp order by deptno, sal desc;
+-------+--------+------+--------+-----------+
| empno | deptno | sal  | ename  | job       |
+-------+--------+------+--------+-----------+
|     9 |     10 | 5000 | KING   | PRESIDENT |
|     7 |     10 | 2450 | CLARK  | MANGER    |
|    14 |     10 | 1300 | MILLER | CLERK     |
|    13 |     20 | 3000 | FORD   | ANALYST   |
|     8 |     20 | 3000 | SCORT  | ANALYST   |
|     4 |     20 | 2975 | JONES  | MANGER    |
|    11 |     20 | 1100 | ADAMS  | CLERK     |
|     1 |     20 |  800 | SMITH  | CLERK     |
|     6 |     30 | 2850 | BLAKE  | MANGER    |
|     2 |     30 | 1600 | ALLEN  | SALESMAN  |
|    10 |     30 | 1500 | TURNER | SALESMAN  |
|     5 |     30 | 1250 | MARTIN | SALESMAN  |
|     3 |     30 | 1250 | WARD   | SALESMAN  |
|    12 |     30 |  950 | JAMES  | CLERK     |
+-------+--------+------+--------+-----------+
14 rows in set (0.00 sec)

按子串排序
mysql> select  ename,job from emp order by substring(job, length(job)-2, 2);
+--------+-----------+
| ename  | job       |
+--------+-----------+
| KING   | PRESIDENT |
| SMITH  | CLERK     |
| JAMES  | CLERK     |
| ADAMS  | CLERK     |
| MILLER | CLERK     |
| BLAKE  | MANGER    |
| CLARK  | MANGER    |
| JONES  | MANGER    |
| MARTIN | SALESMAN  |
| TURNER | SALESMAN  |
| WARD   | SALESMAN  |
| ALLEN  | SALESMAN  |
| FORD   | ANALYST   |
| SCORT  | ANALYST   |
+--------+-----------+
14 rows in set (0.28 sec)

处理排序空值
mysql> select ename,sal,comm,!isnull(comm) as is_null from emp order by is_null desc,comm;
+--------+------+------+---------+
| ename  | sal  | comm | is_null |
+--------+------+------+---------+
| TURNER | 1500 |    0 |       1 |
| ALLEN  | 1600 |  300 |       1 |
| WARD   | 1250 |  500 |       1 |
| MARTIN | 1250 | 1400 |       1 |
| SMITH  |  800 | NULL |       0 |
| FORD   | 3000 | NULL |       0 |
| JAMES  |  950 | NULL |       0 |
| ADAMS  | 1100 | NULL |       0 |
| KING   | 5000 | NULL |       0 |
| SCORT  | 3000 | NULL |       0 |
| CLARK  | 2450 | NULL |       0 |
| BLAKE  | 2850 | NULL |       0 |
| JONES  | 2975 | NULL |       0 |
| MILLER | 1300 | NULL |       0 |
+--------+------+------+---------+
14 rows in set (0.00 sec)

mysql> select ename,sal,comm from (select ename,sal,comm,!isnull(comm) as is_null from emp) x order by is_null desc,comm;
+--------+------+------+
| ename  | sal  | comm |
+--------+------+------+
| TURNER | 1500 |    0 |
| ALLEN  | 1600 |  300 |
| WARD   | 1250 |  500 |
| MARTIN | 1250 | 1400 |
| CLARK  | 2450 | NULL |
| ADAMS  | 1100 | NULL |
| BLAKE  | 2850 | NULL |
| MILLER | 1300 | NULL |
| SMITH  |  800 | NULL |
| KING   | 5000 | NULL |
| FORD   | 3000 | NULL |
| JONES  | 2975 | NULL |
| SCORT  | 3000 | NULL |
| JAMES  |  950 | NULL |
+--------+------+------+
14 rows in set (0.02 sec)

mysql> select ename,sal,comm from (select ename,sal,comm,!isnull(comm) as is_null from emp) x order by is_null asc,comm;
+--------+------+------+
| ename  | sal  | comm |
+--------+------+------+
| CLARK  | 2450 | NULL |
| ADAMS  | 1100 | NULL |
| BLAKE  | 2850 | NULL |
| MILLER | 1300 | NULL |
| SMITH  |  800 | NULL |
| KING   | 5000 | NULL |
| FORD   | 3000 | NULL |
| JONES  | 2975 | NULL |
| SCORT  | 3000 | NULL |
| JAMES  |  950 | NULL |
| TURNER | 1500 |    0 |
| ALLEN  | 1600 |  300 |
| WARD   | 1250 |  500 |
| MARTIN | 1250 | 1400 |
+--------+------+------+
14 rows in set (0.00 sec)

mysql> select isnull(24),isnull(null);
+------------+--------------+
| isnull(24) | isnull(null) |
+------------+--------------+
|          0 |            1 |
+------------+--------------+
1 row in set (0.00 sec)

根据数据项的键排序
根据某些逻辑来排序
mysql> select ename,sal,job,comm from emp order by
    -> case when job = 'SALESMAN' then comm else sal end;
+--------+------+-----------+------+
| ename  | sal  | job       | comm |
+--------+------+-----------+------+
| TURNER | 1500 | SALESMAN  |    0 |
| ALLEN  | 1600 | SALESMAN  |  300 |
| WARD   | 1250 | SALESMAN  |  500 |
| SMITH  |  800 | CLERK     | NULL |
| JAMES  |  950 | CLERK     | NULL |
| ADAMS  | 1100 | CLERK     | NULL |
| MILLER | 1300 | CLERK     | NULL |
| MARTIN | 1250 | SALESMAN  | 1400 |
| CLARK  | 2450 | MANGER    | NULL |
| BLAKE  | 2850 | MANGER    | NULL |
| JONES  | 2975 | MANGER    | NULL |
| FORD   | 3000 | ANALYST   | NULL |
| SCORT  | 3000 | ANALYST   | NULL |
| KING   | 5000 | PRESIDENT | NULL |
+--------+------+-----------+------+
14 rows in set (0.00 sec)

mysql> select ename,sal,job,comm,if(job='SALESMAN',comm,sal) as ordered from emp order by 5;
+--------+------+-----------+------+---------+
| ename  | sal  | job       | comm | ordered |
+--------+------+-----------+------+---------+
| TURNER | 1500 | SALESMAN  |    0 |       0 |
| ALLEN  | 1600 | SALESMAN  |  300 |     300 |
| WARD   | 1250 | SALESMAN  |  500 |     500 |
| SMITH  |  800 | CLERK     | NULL |     800 |
| JAMES  |  950 | CLERK     | NULL |     950 |
| ADAMS  | 1100 | CLERK     | NULL |    1100 |
| MILLER | 1300 | CLERK     | NULL |    1300 |
| MARTIN | 1250 | SALESMAN  | 1400 |    1400 |
| CLARK  | 2450 | MANGER    | NULL |    2450 |
| BLAKE  | 2850 | MANGER    | NULL |    2850 |
| JONES  | 2975 | MANGER    | NULL |    2975 |
| FORD   | 3000 | ANALYST   | NULL |    3000 |
| SCORT  | 3000 | ANALYST   | NULL |    3000 |
| KING   | 5000 | PRESIDENT | NULL |    5000 |
+--------+------+-----------+------+---------+
14 rows in set (0.00 sec)

mysql> select ename,sal,job,comm from emp order by if(job='SALESMAN',comm,sal);
+--------+------+-----------+------+
| ename  | sal  | job       | comm |
+--------+------+-----------+------+
| TURNER | 1500 | SALESMAN  |    0 |
| ALLEN  | 1600 | SALESMAN  |  300 |
| WARD   | 1250 | SALESMAN  |  500 |
| SMITH  |  800 | CLERK     | NULL |
| JAMES  |  950 | CLERK     | NULL |
| ADAMS  | 1100 | CLERK     | NULL |
| MILLER | 1300 | CLERK     | NULL |
| MARTIN | 1250 | SALESMAN  | 1400 |
| CLARK  | 2450 | MANGER    | NULL |
| BLAKE  | 2850 | MANGER    | NULL |
| JONES  | 2975 | MANGER    | NULL |
| FORD   | 3000 | ANALYST   | NULL |
| SCORT  | 3000 | ANALYST   | NULL |
| KING   | 5000 | PRESIDENT | NULL |
+--------+------+-----------+------+
14 rows in set (0.00 sec)

操作多个表
记录的叠加
将多个来源的行组合起来，放在一个结果集中。所有select列表中的数目对应项
目中的数据类型必须匹配，这跟所有的集合的操作要求相同。

通常查询中，不要使用distinct,除非确有必要这样做；对于union而言也是如此。
除非确有必要，一般使用union all,而使用union.
因为使用union,很可能会为了去重复项而进行排序操作。
mysql> select ename as ename_and_dname,deptno from emp where deptno=10
    -> union all
    -> select '-------------', null
    -> from t1
    -> union all
    -> select dname, deptno
    -> from dept;
 select ename as ename_and_dname,deptno from emp where deptno=10 union all select '-------------', null from t1 union all select dname, deptno from dept;
+-----------------+--------+
| ename_and_dname | deptno |
+-----------------+--------+
| CLARK           |     10 |
| KING            |     10 |
| MILLER          |     10 |
| -------------   |   NULL |
| ACCOUNTING      |     10 |
| RESEARCH        |     20 |
| SALES           |     30 |
| OPERATIONS      |     40 |
+-----------------+--------+


组合相关行
mysql> select e.ename,e.job,d.loc from emp e,dept d where e.deptno = d.deptno;
+--------+-----------+----------+
| ename  | job       | loc      |
+--------+-----------+----------+
| CLARK  | MANGER    | NEW YORK |
| KING   | PRESIDENT | NEW YORK |
| MILLER | CLERK     | NEW YORK |
| SMITH  | CLERK     | DALLAS   |
| JONES  | MANGER    | DALLAS   |
| SCORT  | ANALYST   | DALLAS   |
| ADAMS  | CLERK     | DALLAS   |
| FORD   | ANALYST   | DALLAS   |
| ALLEN  | SALESMAN  | CHICAGO  |
| WARD   | SALESMAN  | CHICAGO  |
| MARTIN | SALESMAN  | CHICAGO  |
| BLAKE  | MANGER    | CHICAGO  |
| TURNER | SALESMAN  | CHICAGO  |
| JAMES  | CLERK     | CHICAGO  |
+--------+-----------+----------+
14 rows in set (0.00 sec)

内联接的一种
mysql> select e.ename,e.job,d.loc from emp e,dept d where e.deptno = d.deptno and e.deptno =10;
+--------+-----------+----------+
| ename  | job       | loc      |
+--------+-----------+----------+
| CLARK  | MANGER    | NEW YORK |
| KING   | PRESIDENT | NEW YORK |
| MILLER | CLERK     | NEW YORK |
+--------+-----------+----------+
3 rows in set (0.00 sec)

等价join
mysql> select e.ename,e.job,d.loc from emp e join dept d on (e.deptno = d.deptno) where e.deptno =10;
+--------+-----------+----------+
| ename  | job       | loc      |
+--------+-----------+----------+
| CLARK  | MANGER    | NEW YORK |
| KING   | PRESIDENT | NEW YORK |
| MILLER | CLERK     | NEW YORK |
+--------+-----------+----------+
3 rows in set (0.01 sec)

在一个表中查询另一表没有的值
mysql> select deptno from dept where deptno not in (select deptno from emp);
+--------+
| deptno |
+--------+
|     40 |
+--------+
1 row in set (0.05 sec)

但是请看下面这个问题：
mysql> create table new_dept(deptno int);
mysql> insert into new_dept values (10),(50),(null); 
mysql> select * from new_dept;
+--------+
| deptno |
+--------+
|     10 |
|     50 |
|   NULL |
+--------+
3 rows in set (0.00 sec)

mysql> select *  from dept where deptno not in (select deptno from new_dept);
Empty set (0.00 sec)
Why?in 和 not in 本质上是or运算，因为or运算时，处理null的方式不同，产生的结果不同。
mysql> select true or null,false or null;
+--------------+---------------+
| true or null | false or null |
+--------------+---------------+
|            1 |          NULL |
+--------------+---------------+
1 row in set (0.00 sec)

解决方案：
not exists 和 相关子查询
mysql> select d.deptno from dept d where not exists(select null from emp e where d.deptno = e.deptno);
+--------+
| deptno |
+--------+
|     40 |
+--------+
1 row in set (0.00 sec)

mysql> select d.deptno from dept d where not exists(select null from new_dept e where d.deptno = e.deptno);
+--------+
| deptno |
+--------+
|     20 |
|     30 |
|     40 |
+--------+
3 rows in set (0.00 sec)
注意： exists 和 not exists 与相关子查询一起使用时，子查询select列表中的项目并不重要，因此，这里选择了null,把重点放在联接子查询上，而不是select列表项目。

先来看下面那个例子，看清 join 和 left join 的区别。
mysql> select d.* from dept d join emp e on (d.deptno = e.deptno) ;
+--------+------------+----------+
| deptno | dname      | loc      |
+--------+------------+----------+
|     10 | ACCOUNTING | NEW YORK |
|     10 | ACCOUNTING | NEW YORK |
|     10 | ACCOUNTING | NEW YORK |
|     20 | RESEARCH   | DALLAS   |
|     20 | RESEARCH   | DALLAS   |
|     20 | RESEARCH   | DALLAS   |
|     20 | RESEARCH   | DALLAS   |
|     20 | RESEARCH   | DALLAS   |
|     30 | SALES      | CHICAGO  |
|     30 | SALES      | CHICAGO  |
|     30 | SALES      | CHICAGO  |
|     30 | SALES      | CHICAGO  |
|     30 | SALES      | CHICAGO  |
|     30 | SALES      | CHICAGO  |
+--------+------------+----------+
14 rows in set (0.00 sec)

mysql> select d.* from dept d left join emp e on (d.deptno = e.deptno) ;
+--------+------------+----------+
| deptno | dname      | loc      |
+--------+------------+----------+
|     10 | ACCOUNTING | NEW YORK |
|     10 | ACCOUNTING | NEW YORK |
|     10 | ACCOUNTING | NEW YORK |
|     20 | RESEARCH   | DALLAS   |
|     20 | RESEARCH   | DALLAS   |
|     20 | RESEARCH   | DALLAS   |
|     20 | RESEARCH   | DALLAS   |
|     20 | RESEARCH   | DALLAS   |
|     30 | SALES      | CHICAGO  |
|     30 | SALES      | CHICAGO  |
|     30 | SALES      | CHICAGO  |
|     30 | SALES      | CHICAGO  |
|     30 | SALES      | CHICAGO  |
|     30 | SALES      | CHICAGO  |
|     40 | OPERATIONS | BOSTON   |  就是它了，left join 时也会列出。
+--------+------------+----------+
15 rows in set (0.01 sec)

mysql> select d.*,e.deptno from dept d left join emp e on (d.deptno = e.deptno)
;
+--------+------------+----------+--------+
| deptno | dname      | loc      | deptno |
+--------+------------+----------+--------+
|     10 | ACCOUNTING | NEW YORK |     10 |
|     10 | ACCOUNTING | NEW YORK |     10 |
|     10 | ACCOUNTING | NEW YORK |     10 |
|     20 | RESEARCH   | DALLAS   |     20 |
|     20 | RESEARCH   | DALLAS   |     20 |
|     20 | RESEARCH   | DALLAS   |     20 |
|     20 | RESEARCH   | DALLAS   |     20 |
|     20 | RESEARCH   | DALLAS   |     20 |
|     30 | SALES      | CHICAGO  |     30 |
|     30 | SALES      | CHICAGO  |     30 |
|     30 | SALES      | CHICAGO  |     30 |
|     30 | SALES      | CHICAGO  |     30 |
|     30 | SALES      | CHICAGO  |     30 |
|     30 | SALES      | CHICAGO  |     30 |
|     40 | OPERATIONS | BOSTON   |   NULL |
+--------+------------+----------+--------+
15 rows in set (0.01 sec)

在一个表中查找与其它表不匹配的记录
使用外联接，然后只保留不匹配的记录。这种操作有时也被称为反联接。
mysql> select d.*,e.deptno from dept d left join emp e on (d.deptno = e.deptno)
 where e.deptno is null;
+--------+------------+--------+--------+
| deptno | dname      | loc    | deptno |
+--------+------------+--------+--------+
|     40 | OPERATIONS | BOSTON |   NULL |
+--------+------------+--------+--------+
1 row in set (0.00 sec)
向查询中增加联接而不影响其他联接
mysql> select * from emp_bonus;
+-------+------------+------+
| empno | received   | type |
+-------+------------+------+
|     8 | 2005-03-14 |    1 |
|     1 | 2005-03-14 |    2 |
|    12 | 2005-03-14 |    3 |
+-------+------------+------+
3 rows in set (0.00 sec)

mysql> select e.ename,d.loc,eb.received from emp e join dept d on (e.deptno=d.deptno) left join emp_bonus eb on (e.empno = eb.empno) order by 2,1;
+--------+----------+------------+
| ename  | loc      | received   |
+--------+----------+------------+
| ALLEN  | CHICAGO  | NULL       |
| BLAKE  | CHICAGO  | NULL       |
| JAMES  | CHICAGO  | 2005-03-14 |
| MARTIN | CHICAGO  | NULL       |
| TURNER | CHICAGO  | NULL       |
| WARD   | CHICAGO  | NULL       |
| ADAMS  | DALLAS   | NULL       |
| FORD   | DALLAS   | NULL       |
| JONES  | DALLAS   | NULL       |
| SCORT  | DALLAS   | 2005-03-14 |
| SMITH  | DALLAS   | 2005-03-14 |
| CLARK  | NEW YORK | NULL       |
| KING   | NEW YORK | NULL       |
| MILLER | NEW YORK | NULL       |
+--------+----------+------------+
14 rows in set (0.02 sec)


检测那个表中是否有相同的数据
mysql> create view v as
    -> select * from emp where deptno != 10
    -> union all
    -> select * from emp where ename = 'WARD';
Query OK, 0 rows affected (0.30 sec)

mysql> select * from v;
+-------+--------+----------+------+------------+------+------+--------+
| empno | ename  | job      | mgr  | hiredate   | sal  | comm | deptno |
+-------+--------+----------+------+------------+------+------+--------+
|     1 | SMITH  | CLERK    | 7902 | 1980-12-17 |  800 | NULL |     20 |
|     2 | ALLEN  | SALESMAN | 7698 | 1981-02-20 | 1600 |  300 |     30 |
|     3 | WARD   | SALESMAN | 7698 | 1981-02-22 | 1250 |  500 |     30 |
|     4 | JONES  | MANGER   | 7839 | 1981-04-02 | 2975 | NULL |     20 |
|     5 | MARTIN | SALESMAN | 7698 | 1980-09-28 | 1250 | 1400 |     30 |
|     6 | BLAKE  | MANGER   | 7839 | 1981-05-01 | 2850 | NULL |     30 |
|     8 | SCORT  | ANALYST  | 7566 | 1982-12-09 | 3000 | NULL |     20 |
|    10 | TURNER | SALESMAN | 7698 | 1981-09-08 | 1500 |    0 |     30 |
|    11 | ADAMS  | CLERK    | 7788 | 1983-12-12 | 1100 | NULL |     20 |
|    12 | JAMES  | CLERK    | 7698 | 1981-12-03 |  950 | NULL |     30 |
|    13 | FORD   | ANALYST  | 7566 | 1981-12-03 | 3000 | NULL |     20 |
|     3 | WARD   | SALESMAN | 7698 | 1981-02-22 | 1250 |  500 |     30 |
+-------+--------+----------+------+------------+------+------+--------+
12 rows in set (0.00 sec)

较为复杂，跳过。

识别和消除笛卡尔积
要返回在部门10中每个员工的姓名，以及部门的工作地点。
mysql> select e.ename,d.dname,d.loc from emp e,dept d where e.deptno = d.deptno and e.deptno = 10;
+--------+------------+----------+
| ename  | dname      | loc      |
+--------+------------+----------+
| CLARK  | ACCOUNTING | NEW YORK |
| KING   | ACCOUNTING | NEW YORK |
| MILLER | ACCOUNTING | NEW YORK |
+--------+------------+----------+
3 rows in set (0.01 sec)


聚集与联接
delete from emp_bonus;
insert into emp_bonus values (14,'2005-03-17', 1);
insert into emp_bonus values (14,'2005-02-15', 2);
insert into emp_bonus values (9,'2005-02-15', 3);
insert into emp_bonus values (7,'2005-02-15', 1);
计算部门10的工资总数，奖金总数
mysql> select d.deptno,d.total_sal,sum(e.sal*case when eb.type=1 then .1
    -> when eb.type = 2 then .2
    -> else .3 end) as total_bonus
    -> from emp e,
    -> emp_bonus eb,
    -> ( select deptno,sum(sal) as total_sal from emp where deptno = 10
    -> group by deptno) d
    -> where e.deptno = d.deptno
    -> and e.empno = eb.empno
    -> group by d.deptno,d.total_sal;
+--------+-----------+-------------+
| deptno | total_sal | total_bonus |
+--------+-----------+-------------+
|     10 |      8750 |      2135.0 |
+--------+-----------+-------------+
1 row in set (0.03 sec)

select d.deptno,d.total_sal,sum(e.sal*case when eb.type=1 then .1 when eb.type = 2 then .2 else .3 end) as total_bonus from emp e, emp_bonus eb, ( select deptno,sum(sal) as total_sal from emp where deptno = 10 group by deptno) d where e.deptno = d.deptno and e.empno = eb.empno group by d.deptno,d.total_sal; 

抑制重复
mysql> select distinct job from emp;
+-----------+
| job       |
+-----------+
| CLERK     |
| SALESMAN  |
| MANGER    |
| ANALYST   |
| PRESIDENT |
+-----------+
5 rows in set (0.00 sec)

mysql> select job from emp group by job;
+-----------+
| job       |
+-----------+
| ANALYST   |
| CLERK     |
| MANGER    |
| PRESIDENT |
| SALESMAN  |
+-----------+
5 rows in set (0.00 sec)

关于distinct,order by 你要知道！
distinct会应用于整个select列表；其它的列可能会更改结果集。

下面这个例子，返回的内容是表中各不相同的job/deptno的组合。
mysql> select distinct job,deptno  from emp;
+-----------+--------+
| job       | deptno |
+-----------+--------+
| CLERK     |     20 |
| SALESMAN  |     30 |
| MANGER    |     20 |
| MANGER    |     30 |
| MANGER    |     10 |
| ANALYST   |     20 |
| PRESIDENT |     10 |
| CLERK     |     30 |
| CLERK     |     10 |
| JEDI      |   NULL |
+-----------+--------+
10 rows in set (0.01 sec)

关于order by，其对非分组的select列并无准确意义可言。
mysql> select job,deptno  from emp group by job;
+-----------+--------+
| job       | deptno |
+-----------+--------+
| ANALYST   |     20 |
| CLERK     |     20 |
| JEDI      |   NULL |
| MANGER    |     20 |
| PRESIDENT |     10 |
| SALESMAN  |     30 |
+-----------+--------+
6 rows in set (0.01 sec)


从多个表中返回丢失的数据
即可能有没有部门的员工，也可能有没有员工的部门
现在要返回所有信息。
方案：使用公共值的安全外联接(在mysql中没发现full outer join)或者左联union右联。
mysql> insert into emp (empno,ename,job,mgr,hiredate,sal,comm,deptno) select 111,'YODA', 'JEDI', null,hiredate,sal,comm,null from emp where ename = 'KING';
mysql> select * from emp where ename='YODA' ;
+-------+-------+------+------+------------+------+------+--------+
| empno | ename | job  | mgr  | hiredate   | sal  | comm | deptno |
+-------+-------+------+------+------------+------+------+--------+
|   111 | YODA  | JEDI | NULL | 1981-11-17 | 5000 | NULL |   NULL |
+-------+-------+------+------+------------+------+------+--------+
1 row in set (0.02 sec)

mysql> select d.deptno,d.dname,e.ename from dept d right join emp e on (d.deptno=e.deptno)
    -> union
    -> select d.deptno,d.dname,e.ename from dept d left join emp e on (d.deptno=
e.deptno) ;
+--------+------------+--------+
| deptno | dname      | ename  |
+--------+------------+--------+
|     20 | RESEARCH   | SMITH  |
|     30 | SALES      | ALLEN  |
|     30 | SALES      | WARD   |
|     20 | RESEARCH   | JONES  |
|     30 | SALES      | MARTIN |
|     30 | SALES      | BLAKE  |
|     10 | ACCOUNTING | CLARK  |
|     20 | RESEARCH   | SCORT  |
|     10 | ACCOUNTING | KING   |
|     30 | SALES      | TURNER |
|     20 | RESEARCH   | ADAMS  |
|     30 | SALES      | JAMES  |
|     20 | RESEARCH   | FORD   |
|     10 | ACCOUNTING | MILLER |
|   NULL | NULL       | YODA   |
|     40 | OPERATIONS | NULL   |
+--------+------------+--------+
16 rows in set (0.00 sec)

在运算和比较时使用null值
mysql> select null=null,null = false,null=0,null='',0=false,0='';
+-----------+--------------+--------+---------+---------+------+
| null=null | null = false | null=0 | null='' | 0=false | 0='' |
+-----------+--------------+--------+---------+---------+------+
|      NULL |         NULL |   NULL |    NULL |       1 |    1 |
+-----------+--------------+--------+---------+---------+------+
1 row in set (0.00 sec)
所以当用到null值来运算或排序时，可以用coalesce函数来转换一下，再进行操作。
根据情况，需要考虑null的行就转化；不需要时直接比较就行了。
mysql> select ename,comm,coalesce(comm, 0) from emp
    -> where coalesce(comm,0)<(select comm from emp where ename='WARD');
+--------+------+-------------------+
| ename  | comm | coalesce(comm, 0) |
+--------+------+-------------------+
| SMITH  | NULL |                 0 |
| ALLEN  |  300 |               300 |
| JONES  | NULL |                 0 |
| BLAKE  | NULL |                 0 |
| CLARK  | NULL |                 0 |
| SCORT  | NULL |                 0 |
| KING   | NULL |                 0 |
| TURNER |    0 |                 0 |
| ADAMS  | NULL |                 0 |
| JAMES  | NULL |                 0 |
| FORD   | NULL |                 0 |
| MILLER | NULL |                 0 |
| YODA   | NULL |                 0 |
+--------+------+-------------------+
13 rows in set (0.02 sec)

mysql> select ename,comm,coalesce(comm, 0) from emp
    -> where comm<(select comm from emp where ename='WARD');
+--------+------+-------------------+
| ename  | comm | coalesce(comm, 0) |
+--------+------+-------------------+
| ALLEN  |  300 |               300 |
| TURNER |    0 |                 0 |
+--------+------+-------------------+
2 rows in set (0.00 sec)

插入、更新与删除
mysql,db2可以选择一次插入一行，或者用多个值列表一次插入多行。
可以使用default来显示指定某列使用默认值。
在mysql中，如果表中所有的列都有默认值的话，可以使用一个空值列表使用默认值： insert into D values ();
在定义了默认值的列插入数据，并且需要不管该列默认值是什么，都将该列值设为null。

复制表定义
mysql> create table dept_east like dept;
Query OK, 0 rows affected (0.36 sec)
mysql> show create table dept_east\G
*************************** 1. row ***************************
       Table: dept_east
Create Table: CREATE TABLE `dept_east` (
  `deptno` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `dname` varchar(80) DEFAULT NULL,
  `loc` varchar(60) DEFAULT NULL,
  UNIQUE KEY `deptno` (`deptno`)       #看，复制包含了键
) ENGINE=InnoDB DEFAULT CHARSET=utf8
1 row in set (0.00 sec)

mysql> show create table dept\G
*************************** 1. row ***************************
       Table: dept
Create Table: CREATE TABLE `dept` (
  `deptno` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `dname` varchar(80) DEFAULT NULL,
  `loc` varchar(60) DEFAULT NULL,
  UNIQUE KEY `deptno` (`deptno`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8
1 row in set (0.00 sec)

mysql> drop table dept_east;
#单纯的复制表结构，不包含键信息
mysql> create table dept_east as select * from dept where 0;
Query OK, 0 rows affected (0.06 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> show create table dept_east\G
*************************** 1. row ***************************
       Table: dept_east
Create Table: CREATE TABLE `dept_east` (
  `deptno` bigint(20) unsigned NOT NULL DEFAULT '0',
  `dname` varchar(80) DEFAULT NULL,
  `loc` varchar(60) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8
1 row in set (0.00 sec)

#复制表结构（不含键信息），同时复制数据过来。
mysql> create table dept_east as select * from dept;
Query OK, 4 rows affected (0.06 sec)
Records: 4  Duplicates: 0  Warnings: 0

mysql> select count(*) from dept_east;
+----------+
| count(*) |
+----------+
|        4 |
+----------+
1 row in set (0.00 sec)

mysql> delete from dept_east;
Query OK, 4 rows affected (0.33 sec)

mysql> insert into dept_east select  * from dept where loc in ('NEW YORK','BOSTON');
Query OK, 2 rows affected (0.27 sec)
Records: 2  Duplicates: 0  Warnings: 0

mysql> select deptno,loc from dept_east;
+--------+----------+
| deptno | loc      |
+--------+----------+
|     10 | NEW YORK |
|     40 | BOSTON   |
+--------+----------+
2 rows in set (0.00 sec)

更改表结构
mysql> alter table emp change sal sal decimal(10,2);
mysql> alter table emp change comm comm decimal(10,2);


改之前，select 看下是个好习惯。
mysql> select deptno,ename,sal as org_sal,
    -> sal*.10 as amt_to_add,
    -> sal*1.10 as new_sal
    -> from emp
    -> where deptno=20
    -> order by 1,5
    -> ;
+--------+-------+---------+------------+---------+
| deptno | ename | org_sal | amt_to_add | new_sal |
+--------+-------+---------+------------+---------+
|     20 | SMITH |     800 |      80.00 |  880.00 |
|     20 | ADAMS |    1100 |     110.00 | 1210.00 |
|     20 | JONES |    2975 |     297.50 | 3272.50 |
|     20 | SCORT |    3000 |     300.00 | 3300.00 |
|     20 | FORD  |    3000 |     300.00 | 3300.00 |
+--------+-------+---------+------------+---------+
5 rows in set (0.00 sec)
mysql> update emp set sal=sal*1.10 where deptno=20;
mysql> select * from emp where deptno=20;
+-------+-------+---------+------+------------+---------+------+--------+
| empno | ename | job     | mgr  | hiredate   | sal     | comm | deptno |
+-------+-------+---------+------+------------+---------+------+--------+
|     1 | SMITH | CLERK   | 7902 | 1980-12-17 |  880.00 | NULL |     20 |
|     4 | JONES | MANGER  | 7839 | 1981-04-02 | 3272.50 | NULL |     20 |
|     8 | SCORT | ANALYST | 7566 | 1982-12-09 | 3300.00 | NULL |     20 |
|    11 | ADAMS | CLERK   | 7788 | 1983-12-12 | 1210.00 | NULL |     20 |
|    13 | FORD  | ANALYST | 7566 | 1981-12-03 | 3300.00 | NULL |     20 |
+-------+-------+---------+------+------------+---------+------+--------+
5 rows in set (0.00 sec)
当再另一表中相应的行存在，更新数据
如果表emp_bonus中存在某位员工，则将员工的工资增加20%(在表emp中)。
update emp set sal = sal*1.20 where empno in (select empno from emp_bonus);
另一方案：
update emp set sal = sal*1.20 where exists (select null from emp_bonus where emp.empno = emp_bonus.empno);
在子查询中使用null值，对更新操作没有不利影响，这样是为了增强语句的可读性，而且还强调一个事实：与使用in操作符查询不同，使用exists的解决方案中，由子查询的where子句决定要更新哪些行，而不是由子查询的select列表中的值决定。

用其它表中的值更新
和上面的是有区别的，上面只是判断其它其它表中有还是没有。
select * from new_sal;
DEPTNO          SAL
-------------------
    10         4000
如题：要用表new_sal中保存的值更新emp中相应员工的工资，条件时emp.deptno与new_sal.deptno相等，将匹配记录的emp.sal更新为new_sal.sal,将emp.comm更新为new_sal.sal的50%。
update emp e set (e.sal,e.comm) = (select ns.sal,ns.sal/2 from new_sal ns where ns.deptno = e.deptno) where exists (select null from new_sal ns where ns.deptno = e.deptno);
#实际测试 
update emp e,new_sal ns set e.sal = ns.sal,e.comm = ns.sal/2  where ns.deptno = e.depno;

note:
UPDATE items,month SET items.price=month.price

WHERE items.id=month.id;

以上的例子显示出了使用逗号操作符的内部联合，但是multiple-table UPDATE语句可以使用在SELECT语句中允许的任何类型的联合，比如LEFT JOIN。 
注释：您不能把ORDER BY或LIMIT与multiple-table UPDATE同时使用。 
在一个被更改的multiple-table UPDATE中，有些列被引用。您只需要这些列的UPDATE权限。有些列被读取了，但是没被修改。您只需要这些列的SELECT权限。 

删除操作
删除所有 
delete from emp;

删除指定的记录：
delete from emp where deptno = 10;

删除单个记录：
delete from emp where empno = 7788;

删除违反参照完整性的记录：
删除被分配到不存在部门的员工记录
delete from emp where not exists(select * from dept where dept.deptno = emp.deptno);
或者
delete from emp where deptno not in ( select deptno from dept);

实施：
mysql> select * from emp where deptno not in (select deptno from dept);
+-------+--------+------+------+------------+---------+---------+--------+
| empno | ename  | job  | mgr  | hiredate   | sal     | comm    | deptno |
+-------+--------+------+------+------------+---------+---------+--------+
|    15 | nodept | suc  |  788 | 1988-08-08 | 5000.00 | 5000.00 |     13 |
+-------+--------+------+------+------------+---------+---------+--------+
1 row in set (0.00 sec)

mysql> delete from emp where not exists(select null from dept where dept.deptno = emp.deptno);
Query OK, 1 row affected (0.01 sec)

mysql> select * from emp where deptno not in (select deptno from dept);         Empty set (0.00 sec)

删除重复记录
mysql> select * from dupes;
+------+------+
| id   | name |
+------+------+
|    1 | jim  |
|    2 | jack |
|    3 | lucy |
|    4 | sun  |
|    5 | jim  |
+------+------+
5 rows in set (0.00 sec)
未解决
delete from dupes where id not in ( select min(id) from dupes d group by d.name);
ERROR 1093 (HY000): You can't specify target table 'dupes' for update in FROM clause



元数据查询
mysql> SELECT USER() ;
+----------------+
| USER()         |
+----------------+
| root@localhost |
+----------------+
1 row in set (0.00 sec)

show databases;
show tables;

判断数据库是否存在:
select * from `information_schema`.`schemata`  where schema_name='wp'\g
*************************** 1. row ***************************
              CATALOG_NAME: NULL
               SCHEMA_NAME: wp
DEFAULT_CHARACTER_SET_NAME: utf8
    DEFAULT_COLLATION_NAME: utf8_general_ci
                  SQL_PATH: NULL
1 row in set (0.00 sec)

判断表是否存在：
select *  from `information_schema`.`tables` where `table_schema`='cookbook' and `table_name`='emp'\g

判断列是否存在：
mysql> select * from information_schema.columns where TABLE_SCHEMA = 'cookbook' and TABLE_NAME = 'emp' and COLUMN_NAME = 'sal'\G
*************************** 1. row ***************************
           TABLE_CATALOG: NULL
            TABLE_SCHEMA: cookbook
              TABLE_NAME: emp
             COLUMN_NAME: sal
        ORDINAL_POSITION: 6
          COLUMN_DEFAULT: NULL
             IS_NULLABLE: YES
               DATA_TYPE: decimal
CHARACTER_MAXIMUM_LENGTH: NULL
  CHARACTER_OCTET_LENGTH: NULL
       NUMERIC_PRECISION: 10
           NUMERIC_SCALE: 2
      CHARACTER_SET_NAME: NULL
          COLLATION_NAME: NULL
             COLUMN_TYPE: decimal(10,2)
              COLUMN_KEY: 
                   EXTRA: 
              PRIVILEGES: select,insert,update,references
          COLUMN_COMMENT: 
1 row in set (0.00 sec)

简单的判断：
mysql> select null from information_schema.columns where TABLE_SCHEMA = 'cookbook' and TABLE_NAME = 'emp' and COLUMN_NAME = 'sal'\G
*************************** 1. row ***************************
NULL: NULL
1 row in set (0.00 sec)

mysql> select column_name,data_type,IS_NULLABLE,NUMERIC_PRECISION,NUMERIC_SCALE,COLUMN_KEY,COLUMN_COMMENT from information_schema.columns where TABLE_SCHEMA = 'cookbook' and TABLE_NAME = 'emp';
+-------------+-----------+-------------+-------------------+---------------+------------+----------------+
| column_name | data_type | IS_NULLABLE | NUMERIC_PRECISION | NUMERIC_SCALE | COLUMN_KEY | COLUMN_COMMENT |
+-------------+-----------+-------------+-------------------+---------------+------------+----------------+
| empno       | bigint    | NO          |                20 |             0 | PRI        |                |
| ename       | varchar   | YES         |              NULL |          NULL |            |                |
| job         | varchar   | YES         |              NULL |          NULL |            |                |
| mgr         | bigint    | YES         |                20 |             0 |            |                |
| hiredate    | date      | YES         |              NULL |          NULL |            |                |
| sal         | decimal   | YES         |                10 |             2 |            |                |
| comm        | decimal   | YES         |                10 |             2 |            |                |
| deptno      | bigint    | YES         |                20 |             0 |            |                |
+-------------+-----------+-------------+-------------------+---------------+------------+----------------+
8 rows in set (0.00 sec)

索引列查询:
mysql> show index from cookbook.emp\G
*************************** 1. row ***************************
       Table: emp
  Non_unique: 0
    Key_name: empno
Seq_in_index: 1
 Column_name: empno
   Collation: A
 Cardinality: 14
    Sub_part: NULL
      Packed: NULL
        Null: 
  Index_type: BTREE
     Comment: 
1 row in set (0.00 sec)


处理数字
平均收入计算
mysql> select avg(sal) as avg_sal from emp;
+-------------+
| avg_sal     |
+-------------+
| 2340.833333 |
+-------------+
1 row in set (0.00 sec)

各部门平均收入
mysql> select deptno,avg(sal) as avg_sal from emp group by deptno;
+--------+-------------+
| deptno | avg_sal     |
+--------+-------------+
|   NULL | 5000.000000 |
|     10 | 2916.666667 |
|     20 | 2392.500000 |
|     30 | 1566.666667 |
+--------+-------------+
4 rows in set (0.00 sec)

note:
avg函数会忽略null值。
create table t2(sal int);
insert into t2 values (10),(20),(null);
mysql> select * from t2;
+------+
| sal  |
+------+
|   10 |
|   20 |
| NULL |
+------+
3 rows in set (0.00 sec)

mysql> select avg(sal) from t2;
+----------+
| avg(sal) |
+----------+
|  15.0000 |
+----------+
1 row in set (0.00 sec)

mysql> select avg(coalesce(sal,0)) from t2;
+----------------------+
| avg(coalesce(sal,0)) |
+----------------------+
|              10.0000 |
+----------------------+
1 row in set (0.02 sec)

最大值 最小值
mysql> select min(sal) as min_sal,max(sal) as max_sal from emp;
+---------+---------+
| min_sal | max_sal |
+---------+---------+
|  880.00 | 5000.00 |
+---------+---------+
1 row in set (0.00 sec)

求和
mysql> select sum(sal) as sum from emp;
+----------+
| sum      |
+----------+
| 35112.50 |
+----------+
1 row in set (0.00 sec)

取余
mysql> select mod(3,5),mod(3,2),mod(3,1),mod(3,0);
+----------+----------+----------+----------+
| mod(3,5) | mod(3,2) | mod(3,1) | mod(3,0) |
+----------+----------+----------+----------+
|        3 |        1 |        0 |     NULL |
+----------+----------+----------+----------+
1 row in set (0.00 sec)


分组求和
sum函数会忽略null,但可以存在null组。
mysql> select deptno,sum(comm) as sum_comm,sum(sal) as sum_sal from emp group by deptno;
+--------+----------+----------+
| deptno | sum_comm | sum_sal  |
+--------+----------+----------+
|   NULL |     NULL |  5000.00 |
|     10 |     NULL |  8750.00 |
|     20 |     NULL | 11962.50 |
|     30 |  2200.00 |  9400.00 |
+--------+----------+----------+
4 rows in set (0.00 sec)

count 数出现次数
mysql> select * from t2;
+------+
| sal  |
+------+
|   10 |
|   20 |
| NULL |
+------+
3 rows in set (0.00 sec)

count(*)得到的是行数（因而实际值null或非null的行都包含）
但是,当对某列进行count运算，则要计算的是该列中具有非null值的行数。
mysql> select count(*) as sum_all,count(sal) as sum_no_null from t2;
+---------+-------------+
| sum_all | sum_no_null |
+---------+-------------+
|       3 |           2 |
+---------+-------------+
1 row in set (0.00 sec)




高级查询
# like 查询，默认不区分大小写的。用binary来达到区分。
mysql> select * from emp where ename like binary '%ar%';
Empty set (0.00 sec)

mysql> select * from emp where ename like '%ar%';
+-------+--------+----------+------+------------+---------+---------+--------+
| empno | ename  | job      | mgr  | hiredate   | sal     | comm    | deptno |
+-------+--------+----------+------+------------+---------+---------+--------+
|     3 | WARD   | SALESMAN | 7698 | 1981-02-22 | 1250.00 |  500.00 |     30 |
|     5 | MARTIN | SALESMAN | 7698 | 1980-09-28 | 1250.00 | 1400.00 |     30 |
|     7 | CLARK  | MANGER   | 7839 | 1981-06-09 | 2450.00 |    NULL |     10 |
+-------+--------+----------+------+------------+---------+---------+--------+
3 rows in set (0.00 sec)

已经有了分隔数据，将其转化为where in列表中的项目。
select * from emp where find_in_set(empno,'1,3,5,7');
+-------+--------+----------+------+------------+---------+---------+--------+
| empno | ename  | job      | mgr  | hiredate   | sal     | comm    | deptno |
+-------+--------+----------+------+------------+---------+---------+--------+
|     1 | SMITH  | CLERK    | 7902 | 1980-12-17 |  800.00 |    NULL |     20 |
|     3 | WARD   | SALESMAN | 7698 | 1981-02-22 | 1250.00 |  500.00 |     30 |
|     5 | MARTIN | SALESMAN | 7698 | 1980-09-28 | 1250.00 |    NULL |     30 |
|     7 | CLARK  | MANGER   | 7839 | 1981-06-09 | 4000.00 | 2000.00 |     10 |
+-------+--------+----------+------+------------+---------+---------+--------+
4 rows in set (0.00 sec)

各部门工资，提成汇总
mysql> select deptno,sum(comm) as sum_comm,sum(sal) as sum_sal from emp group by
 deptno;
+--------+----------+----------+
| deptno | sum_comm | sum_sal  |
+--------+----------+----------+
|   NULL |     NULL |  5000.00 |
|     10 |     NULL |  8750.00 |
|     20 |     NULL | 11962.50 |
|     30 |  2200.00 |  9400.00 |
+--------+----------+----------+
4 rows in set (0.00 sec)

给结果集分页
mysql> select sal from emp order by sal limit 5 offset 0;
    ==
mysql> select sal from emp order by sal limit 0,5;

在外联接中使用or等条件
返回部门10和20中所有员工的姓名和部门信息，并返回部门30和40（但不
包含员工信息）的部门信息。
mysql> select e.ename, d.deptno, d.dname, d.loc from dept d 
left join emp e on 
( d.deptno = e.deptno and (e.deptno = 10 or e.deptno = 20)) 
order by 2;
+--------+--------+------------+----------+
| ename  | deptno | dname      | loc      |
+--------+--------+------------+----------+
| KING   |     10 | ACCOUNTING | NEW YORK |
| MILLER |     10 | ACCOUNTING | NEW YORK |
| CLARK  |     10 | ACCOUNTING | NEW YORK |
| ADAMS  |     20 | RESEARCH   | DALLAS   |
| JONES  |     20 | RESEARCH   | DALLAS   |
| FORD   |     20 | RESEARCH   | DALLAS   |
| SCORT  |     20 | RESEARCH   | DALLAS   |
| SMITH  |     20 | RESEARCH   | DALLAS   |
| NULL   |     30 | SALES      | CHICAGO  |
| NULL   |     40 | OPERATIONS | BOSTON   |
+--------+--------+------------+----------+
10 rows in set (0.38 sec)

给结果分等级
mysql> select (select count(distinct b.sal) from emp b where b.sal <= a.sal) as
rank, a.sal from emp a order by rank;
+------+---------+
| rank | sal     |
+------+---------+
|    1 |  880.00 |
|    2 |  950.00 |
|    3 | 1210.00 |
|    4 | 1250.00 |
|    4 | 1250.00 |
|    5 | 1300.00 |
|    6 | 1500.00 |
|    7 | 1600.00 |
|    8 | 2450.00 |
|    9 | 2850.00 |
|   10 | 3272.50 |
|   11 | 3300.00 |
|   11 | 3300.00 |
|   12 | 5000.00 |
|   12 | 5000.00 |
+------+---------+
15 rows in set (0.02 sec)

# 同上，但是加个distinct 只列等级标准，而不是每个具体的值
mysql> select distinct (select count(distinct b.sal) from emp b where b.sal <= a
.sal) as rank, a.sal from emp a order by rank;
+------+---------+
| rank | sal     |
+------+---------+
|    1 |  880.00 |
|    2 |  950.00 |
|    3 | 1210.00 |
|    4 | 1250.00 |
|    5 | 1300.00 |
|    6 | 1500.00 |
|    7 | 1600.00 |
|    8 | 2450.00 |
|    9 | 2850.00 |
|   10 | 3272.50 |
|   11 | 3300.00 |
|   12 | 5000.00 |
+------+---------+
12 rows in set (0.00 sec)

#模式匹配 正则的运用
mysql> SELECT * from emp where ename  REGEXP '^[a-d]';
+-------+-------+----------+------+------------+---------+--------+--------+
| empno | ename | job      | mgr  | hiredate   | sal     | comm   | deptno |
+-------+-------+----------+------+------------+---------+--------+--------+
|     2 | ALLEN | SALESMAN | 7698 | 1981-02-20 | 1600.00 | 300.00 |     30 |
|     6 | BLAKE | MANGER   | 7839 | 1981-05-01 | 2850.00 |   NULL |     30 |
|     7 | CLARK | MANGER   | 7839 | 1981-06-09 | 2450.00 |   NULL |     10 |
|    11 | ADAMS | CLERK    | 7788 | 1983-12-12 | 1210.00 |   NULL |     20 |
+-------+-------+----------+------+------------+---------+--------+--------+
4 rows in set (0.00 sec)




报表与数据仓库运算
统计每个部门的人数
mysql> select deptno,count(deptno) as cnt from emp group by deptno;
+--------+-----+
| deptno | cnt |
+--------+-----+
|     10 |   3 |
|     20 |   5 |
|     30 |   6 |
+--------+-----+
3 rows in set (0.02 sec)
部门人数大于3的部门列表，及人数
一个HAVING子句必须位于GROUP BY子句之后，并位于ORDER BY子句之前。

mysql> select deptno,count(deptno) as cnt from emp group by deptno having count(
*) > 3;
+--------+-----+
| deptno | cnt |
+--------+-----+
|     20 |   5 |
|     30 |   6 |
+--------+-----+
2 rows in set (0.00 sec)


部门人员统计
mysql> select deptno,group_concat(ename order by empno separator '|') as emps from emp group by deptno;
+--------+--------------------------------------+
| deptno | emps                                 |
+--------+--------------------------------------+
|     10 | CLARK|KING|MILLER                    |
|     20 | SMITH|JONES|SCORT|ADAMS|FORD         |
|     30 | ALLEN|WARD|MARTIN|BLAKE|TURNER|JAMES |
+--------+--------------------------------------+
3 rows in set (0.00 sec)


转置
各部门的人数统计
mysql> select deptno,count(*) as nums from emp group by deptno;
+--------+------+
| deptno | nums |
+--------+------+
|   NULL |    1 |
|     10 |    3 |
|     20 |    5 |
|     30 |    6 |
+--------+------+
4 rows in set (0.02 sec)

[不同时期的结果]
mysql> select sum(case when deptno=10 then 1 else 0 end) as deptno_10,
    -> sum(case when deptno=20 then 1 else 0 end) as deptno_20,
    -> sum(case when deptno=30 then 1 else 0 end) as deptno_30
    -> from emp;
+-----------+-----------+-----------+
| deptno_10 | deptno_20 | deptno_30 |
+-----------+-----------+-----------+
|         3 |         5 |         6 |
+-----------+-----------+-----------+
1 row in set (0.00 sec)
mysql> select sum(if(deptno=10,1,0)) as deptno_10,
    -> sum(if(deptno=20,1,0)) as deptno_20,
    -> sum(if(deptno=30,1,0)) as deptno_30
    -> from emp;
+-----------+-----------+-----------+
| deptno_10 | deptno_20 | deptno_30 |
+-----------+-----------+-----------+
|         3 |         5 |         6 |
+-----------+-----------+-----------+
1 row in set (0.00 sec)

每个部门中工资最高，最低；每种职业中工资最高，最低；
的员工，姓名，职位，工资。
select deptno,ename,job,sal,
  case 
    when sal = max_by_dept
    then
      'Top sal in dept'
    when sal = min_by_dept
    then
      'Low sal in dept'
  end as dept_status,
  case
    when sal = max_by_job
    then 
      'Top sal in job'
    when sal = min_by_job
    then 
      'Low sal in job'  
  end as job_status
from 
(
  select
  e.deptno,e.ename,e.job,e.sal, 
  (select max(sal) from emp d where d.deptno = e.deptno) as max_by_dept,
  (select min(sal) from emp d where d.deptno = e.deptno) as min_by_dept,
  (select max(sal) from emp d where d.job = e.job) as max_by_job,
  (select min(sal) from emp d where d.job = e.job) as min_by_job
   from emp e
) x
where x.sal in (x.max_by_dept,x.min_by_dept,x.max_by_job,x.min_by_job) order by deptno;
+--------+--------+-----------+---------+-----------------+----------------+
| deptno | ename  | job       | sal     | dept_status     | job_status     |
+--------+--------+-----------+---------+-----------------+----------------+
|   NULL | YODA   | JEDI      | 5000.00 | NULL            | Top sal in job |
|     10 | KING   | PRESIDENT | 5000.00 | Top sal in dept | Top sal in job |
|     10 | MILLER | CLERK     | 1300.00 | Low sal in dept | Top sal in job |
|     10 | CLARK  | MANGER    | 2450.00 | NULL            | Low sal in job |
|     20 | JONES  | MANGER    | 3272.50 | NULL            | Top sal in job |
|     20 | FORD   | ANALYST   | 3300.00 | Top sal in dept | Top sal in job |
|     20 | SCORT  | ANALYST   | 3300.00 | Top sal in dept | Top sal in job |
|     20 | SMITH  | CLERK     |  880.00 | Low sal in dept | Low sal in job |
|     30 | ALLEN  | SALESMAN  | 1600.00 | NULL            | Top sal in job |
|     30 | BLAKE  | MANGER    | 2850.00 | Top sal in dept | NULL           |
|     30 | WARD   | SALESMAN  | 1250.00 | NULL            | Low sal in job |
|     30 | JAMES  | CLERK     |  950.00 | Low sal in dept | NULL           |
|     30 | MARTIN | SALESMAN  | 1250.00 | NULL            | Low sal in job |
+--------+--------+-----------+---------+-----------------+----------------+
13 rows in set (0.00 sec)

#简单小计
每个职位工资总和，及小计。
mysql> select coalesce(job, 'Total') job,
    -> sum(sal) sal
    -> from emp
    -> group by job with rollup;
+-----------+----------+
| job       | sal      |
+-----------+----------+
| ANALYST   |  6600.00 |
| CLERK     |  4340.00 |
| JEDI      |  5000.00 |
| MANGER    |  8572.50 |
| PRESIDENT |  5000.00 |
| SALESMAN  |  5600.00 |
| Total     | 35112.50 |
+-----------+----------+
7 rows in set, 1 warning (0.00 sec)



函数
mysql> select ascii('a'),ascii('z'),ascii('A'),ascii('Z'),ascii(0),ascii(9);
+------------+------------+------------+------------+----------+----------+
| ascii('a') | ascii('z') | ascii('A') | ascii('Z') | ascii(0) | ascii(9) |
+------------+------------+------------+------------+----------+----------+
|         97 |        122 |         65 |         90 |       48 |       57 |
+------------+------------+------------+------------+----------+----------+
1 row in set (0.00 sec)



group by 专题
组是非空的。
create table fruits(name varchar(10));
select name from fruits group by name;
Empty set (0.00 sec)

mysql> select count(*) from fruits group by name;
Empty set (0.00 sec)
组是独特的。
insert into fruits values ('oranges'),('oranges'),('oranges'),('apple'),('banana');
mysql> select name,count(*) from fruits group by name;
+---------+----------+
| name    | count(*) |
+---------+----------+
| apple   |        1 |
| banana  |        1 |
| oranges |        3 |
+---------+----------+
3 rows in set (0.02 sec)

当查询中使用group by 时,select 列表中就不必使用dintinct关键字。那是多余的。
insert into fruits values ('null'),('null'),('null');
mysql> select name,count(*) from fruits group by name;
+---------+----------+
| name    | count(*) |
+---------+----------+
| apple   |        1 |
| banana  |        1 |
| null    |        3 |
| oranges |        3 |
+---------+----------+
4 rows in set (0.00 sec)

mysql> select name,count(name) from fruits group by name;
+---------+-------------+
| name    | count(name) |
+---------+-------------+
| apple   |           1 |
| banana  |           1 |
| null    |           3 |
| oranges |           3 |
+---------+-------------+
4 rows in set (0.00 sec)

union and union all
union为集合操作，union all 为多集操作
mysql> select name,count(name) from fruits group by name union
    -> select name,count(name) from fruits group by name;
+---------+-------------+
| name    | count(name) |
+---------+-------------+
| apple   |           1 |
| banana  |           1 |
| null    |           3 |
| oranges |           3 |
+---------+-------------+
4 rows in set (0.00 sec)

union为集合操作，union all 为多集操作
mysql> select name,count(name) from fruits group by name union all
    -> select name,count(name) from fruits group by name;
+---------+-------------+
| name    | count(name) |
+---------+-------------+
| apple   |           1 |
| banana  |           1 |
| null    |           3 |
| oranges |           3 |
| apple   |           1 |
| banana  |           1 |
| null    |           3 |
| oranges |           3 |
+---------+-------------+
8 rows in set (0.00 sec)

note:
通常，在使用group by 和聚集函数时，select 列表[from 子句中的表]中的项，如果没有用作聚集函数的参数，那么一定要在group by子句中包含它们。然而MySQL有一个“特性”，允许偏离这种规则，允许把select列表中没有用作聚集函数的参数的项[select对象表的列]，也不必包含在group by子句中。应该避免此类使用，以免影响准确性。

《The Essence Of SQL》
只选cs112的学生
这个不对，这是所有选了cs112的学生.
mysql> select s.* from  student s,take t where s.sno = t.sno and t.cno = 'cs112'
;
+-----+--------+------+
| sno | sname  | age  |
+-----+--------+------+
|   2 | chuck  |   21 |
|   3 | doug   |   20 |
|   4 | maggie |   19 |
|   1 | aaron  |   20 |
+-----+--------+------+
4 rows in set (0.02 sec)

只选一门课的学生
select sno from take group by sno hav
ing count(*) = 1;

只选cs112的学生
mysql> select s.* from student s,take t1,
( select sno from take group by sno hav
ing count(*) = 1) t2 
where s.sno = t1.sno and t1.sno = t2.sno and t1.cno = 'cs112';
+-----+-------+------+
| sno | sname | age  |
+-----+-------+------+
|   2 | chuck |   21 |
+-----+-------+------+
1 row in set (0.00 sec)

选了课,但是所选课程个数小于等于2门的学生情况.
mysql> select s.sno,s.sname,s.age from student s,take t where s.sno=t.sno group
by s.sno,s.sname,s.age having count(*) <= 2;
+-----+--------+------+
| sno | sname  | age  |
+-----+--------+------+
|   2 | chuck  |   21 |
|   3 | doug   |   20 |
|   4 | maggie |   19 |
|   5 | steve  |   22 |
|   6 | jing   |   18 |
+-----+--------+------+
5 rows in set (0.01 sec)

只教一门课的教授
mysql> select p.lname,p.dept,p.salary,p.age from professor p,teach t where p.lna
me = t.lname group by p.lname,p.dept,p.salary,p.age having count(*) = 1;
+-------+---------+--------+------+
| lname | dept    | salary | age  |
+-------+---------+--------+------+
| pomel | science |    500 |   65 |
+-------+---------+--------+------+
1 row in set (0.00 sec)

只选cs112,cs114的学生。
这是错误的，不会有这样的行存在。
mysql> select s.sno,s.sname from student s,take t where s.sno = t.sno and t.cno
= 'cs112' and t.cno = 'cs114';
Empty set (0.00 sec)

答案：
mysql> select s.sno,s.sname,s.age from student s, take t 
where s.sno = t.sno 
group by s.sno, s.sname, s.age having count(*) = 2 
and max(case when cno = 'cs112' then 1 else 0 end) + max(case when cno = 'cs114' then 1 else 0 end) = 2;
+-----+-------+------+
| sno | sname | age  |
+-----+-------+------+
|   3 | doug  |   20 |
+-----+-------+------+
1 row in set (0.00 sec)
分解：
选两门课的学生
mysql> select s.sno,s.sname,s.age from student s, take t where s.sno = t.sno gro
up by s.sno, s.sname, s.age having count(*) = 2;
+-----+--------+------+
| sno | sname  | age  |
+-----+--------+------+
|   3 | doug   |   20 |
|   4 | maggie |   19 |
|   6 | jing   |   18 |
+-----+--------+------+
3 rows in set (0.00 sec)
选cs112,cs114的学生。
mysql> select s.sno,s.sname,s.age from student s, take t where s.sno = t.sno gro
up by s.sno, s.sname, s.age having max(case when cno = 'cs112' then 1 else 0 end
) + max(case when cno = 'cs114' then 1 else 0 end) = 2;
+-----+-------+------+
| sno | sname | age  |
+-----+-------+------+
|   1 | aaron |   20 |
|   3 | doug  |   20 |
+-----+-------+------+
2 rows in set (0.02 sec)

选择所有课程的同学信息
第一种思路：
所选课程个数等于课程的数量
select s.sno,s.sname,s.age from student s,take t 
where  s.sno = t.sno group by s.sno,s.sname,s.age
having count(t.cno) = (select count(*) from course);
+-----+-------+------+
| sno | sname | age  |
+-----+-------+------+
|   1 | aaron |   20 |
+-----+-------+------+
1 row in set (0.00 sec)
第二种思路：
不属于（有课程没选的学生），即选了所有课程的学生
select * from student
where sno not in
(select s.sno from student s,course c where (s.sno,c.cno) not in(select sno,cno from take));
+-----+-------+------+
| sno | sname | age  |
+-----+-------+------+
|   1 | aaron |   20 |
+-----+-------+------+
1 row in set (0.00 sec)
年龄最大的学生
mysql> select * from student where age = (select max(age) from student);
+-----+-------+------+
| sno | sname | age  |
+-----+-------+------+
|   5 | steve |   22 |
+-----+-------+------+
1 row in set (0.00 sec)





引用手册
SELECT
    [ALL | DISTINCT | DISTINCTROW ]
      [HIGH_PRIORITY]
      [STRAIGHT_JOIN]
      [SQL_SMALL_RESULT] [SQL_BIG_RESULT] [SQL_BUFFER_RESULT]
      [SQL_CACHE | SQL_NO_CACHE] [SQL_CALC_FOUND_ROWS]
    select_expr, ...
    [INTO OUTFILE 'file_name' export_options
      | INTO DUMPFILE 'file_name']
    [FROM table_references
    [WHERE where_definition]
    [GROUP BY {col_name | expr | position}
      [ASC | DESC], ... [WITH ROLLUP]]
    [HAVING where_definition]
    [ORDER BY {col_name | expr | position}
      [ASC | DESC] , ...]
    [LIMIT {[offset,] row_count | row_count OFFSET offset}]
    [PROCEDURE procedure_name(argument_list)]
    [FOR UPDATE | LOCK IN SHARE MODE]]

ALTER TABLE cookbook.student
 CHANGE sno sno INT(11) UNSIGNED primary key AUTO_INCREMENT NOT NULL ;

·         HAVING子句基本上是最后使用，只位于被发送给客户端的条目之前，没有进行优化。（LIMIT用于HAVING之后。）

SQL标准要求HAVING必须引用GROUP BY子句中的列或用于总计函数中的列。不过，MySQL支持对此工作性质的扩展，并允许HAVING因为SELECT清单中的列和外部子查询中的列。

如果HAVING子句引用了一个意义不明确的列，则会出现警告。在下面的语句中，col2意义不明确，因为它既作为别名使用，又作为列名使用：

mysql> SELECT COUNT(col1) AS col2 FROM t GROUP BY col2 HAVING col2 = 2;
标准SQL工作性质具有优先权，因此如果一个HAVING列名既被用于GROUP BY，又被用作输出列清单中的起了别名的列，则优先权被给予GROUP BY列中的列。

·         HAVING不能用于应被用于WHERE子句的条目。例如，不能编写如下语句：

·                mysql> SELECT col_name FROM tbl_name HAVING col_name > 0;
而应这么编写：

mysql> SELECT col_name FROM tbl_name WHERE col_name > 0;
·         HAVING子句可以引用总计函数，而WHERE子句不能引用：

·                mysql> SELECT user, MAX(salary) FROM users
·                    ->     GROUP BY user HAVING MAX(salary)>10;
（在有些较早版本的MySQL中，本语句不运行。）

同一张表 交集问题
film_id typei_id sort_id
4         6           52
5         6           56
4         2           28
 select * from T t where (t.type_id=6 and t.sort_id=52) and t.film_id in  ( select film_id from T where type_id=2 and sort_id=28)
  select * from T t join T t1 on (t.film_id = t1.film_id) where (t.type_id=6 and t.sort_id=52) and (t1.type_id=2 and t1.sort_id=28)

#基于SQL Cookbook  和 MySQL Cookbook
#2012-04-29 14:25:20
```
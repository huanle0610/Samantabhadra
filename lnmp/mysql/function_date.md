## 时间函数
```html
mysql> select curdate(),datediff(curdate(),'20120528');
+------------+--------------------------------+
| curdate()  | datediff(curdate(),'20120528') |
+------------+--------------------------------+
| 2012-05-08 |                            -20 |
+------------+--------------------------------+
1 row in set (0.00 sec)

mysql> select unix_timestamp();
+------------------+
| unix_timestamp() |
+------------------+
|       1332987032 |
+------------------+
1 row in set (0.00 sec)

mysql> select unix_timestamp(curdate());
+---------------------------+
| unix_timestamp(curdate()) |
+---------------------------+
|                1332950400 |
+---------------------------+
1 row in set (0.00 sec)
mysql> select unix_timestamp();
+------------------+
| unix_timestamp() |
+------------------+
|       1332744845 |
+------------------+
1 row in set (0.00 sec)

mysql> select unix_timestamp('1970-01-01');
+------------------------------+
| unix_timestamp('1970-01-01') |
+------------------------------+
|                            0 |
+------------------------------+
1 row in set (0.00 sec)

mysql> select unix_timestamp('1970-01-02');
+------------------------------+
| unix_timestamp('1970-01-02') |
+------------------------------+
|                        57600 |
+------------------------------+
1 row in set (0.00 sec)

mysql> select unix_timestamp('1970-01-03');
+------------------------------+
| unix_timestamp('1970-01-03') |
+------------------------------+
|                       144000 |
+------------------------------+
1 row in set (0.00 sec)

mysql> select FROM_UNIXTIME('1319164120');
+-----------------------------+
| FROM_UNIXTIME('1319164120') |
+-----------------------------+
| 2011-10-21 10:28:40         |
+-----------------------------+
1 row in set (0.00 sec)

mysql> select date(FROM_UNIXTIME('1319164120'));
+-----------------------------------+
| date(FROM_UNIXTIME('1319164120')) |
+-----------------------------------+
| 2011-10-21                        |
+-----------------------------------+
1 row in set (0.00 sec)


mysql> select date_format(date(FROM_UNIXTIME('1319164120')),'%b %d %W');
+-----------------------------------------------------------+
| date_format(date(FROM_UNIXTIME('1319164120')),'%b %d %W') |
+-----------------------------------------------------------+
| Oct 21 Friday                                             |
+-----------------------------------------------------------+
1 row in set (0.00 sec)

mysql> select date_format(FROM_UNIXTIME(i.post_time),'%Y-%m-%d %H:%i:%s') as pos
t_time from (select 1332920772 as post_time) i;
+---------------------+
| post_time           |
+---------------------+
| 2012-03-28 15:46:12 |
+---------------------+
1 row in set (0.00 sec)

mysql> select FROM_UNIXTIME(i.post_time) as post_time from (select 1332920772 as
 post_time) i;
+---------------------+
| post_time           |
+---------------------+
| 2012-03-28 15:46:12 |
+---------------------+
1 row in set (0.00 sec)


mysql> select date_add(curdate(),INTERVAL 1 DAY);
+------------------------------------+
| date_add(curdate(),INTERVAL 1 DAY) |
+------------------------------------+
| 2012-03-30                         |
+------------------------------------+
1 row in set (0.00 sec)

mysql> select date_sub(curdate(),INTERVAL 1 DAY);
+------------------------------------+
| date_sub(curdate(),INTERVAL 1 DAY) |
+------------------------------------+
| 2012-03-28                         |
+------------------------------------+
1 row in set (0.00 sec)

mysql> select date_sub(curdate(),INTERVAL 1 WEEK);
+-------------------------------------+
| date_sub(curdate(),INTERVAL 1 WEEK) |
+-------------------------------------+
| 2012-03-22                          |
+-------------------------------------+
1 row in set (0.00 sec)

mysql> select date_add(curdate(),INTERVAL 1 WEEK);
+-------------------------------------+
| date_add(curdate(),INTERVAL 1 WEEK) |
+-------------------------------------+
| 2012-04-05                          |
+-------------------------------------+
1 row in set (0.00 sec)

mysql> select unix_timestamp(curdate());   //当前时期之时间戳
+---------------------------+
| unix_timestamp(curdate()) |
+---------------------------+
|                1332950400 |
+---------------------------+
1 row in set (0.00 sec)

mysql> select FROM_UNIXTIME(unix_timestamp(curdate()));
+------------------------------------------+
| FROM_UNIXTIME(unix_timestamp(curdate())) |
+------------------------------------------+
| 2012-04-24 00:00:00                      |
+------------------------------------------+
1 row in set (0.00 sec)


set @month =  '2012-02-01';
set @b =2;
select @month,date_add(@month,INTERVAL 1 MONTH), EXTRACT(YEAR_MONTH FROM date_add(@month,INTERVAL @b MONTH));

select round(2.4454,2) as '四舍五入',ceil(2.443) as '小数进位',floor(3.7) as '小数舍弃';

SELECT *, DATE_FORMAT(FROM_UNIXTIME(`act_date`),'%Y-%m-%d %H:%i:%s') AS date_time FROM exp_cp_log;
SELECT * FROM exp_cp_log WHERE DATE(FROM_UNIXTIME(`act_date`)) = '2014-07-13';
```
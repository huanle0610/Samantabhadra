## Special

### 双字段组合重复

```html
SELECT 
  p1.* , GROUP_CONCAT(p1.`primary_key_field`)
FROM
  `field_b` p1 
GROUP BY CONCAT(
    p1.`field_a`,
    p1.`field_b`
  ) 
HAVING COUNT(
    CONCAT(
      p1.`field_a`,
      p1.`field_b`
    )
  ) > 1
```


### 忘记root密码
1. 停止MySQL
    ```html
    sudo service mysql stop
    ```

2. 忽略权限表，启动mysql

   - 忽略权限表

       有两种方式，一种是命令行参数；一种是修改配置文件
    
       bin/mysqld_safe --skip-grant-tables &
    
       推荐下面这种：mysqld配置段加忽略权限选项
    
        ```html
        #  vi /etc/my.cnf
        
        [mysqld]
        skip-grant-tables
    ```

   - 启动mysql
   
        ```html
        sudo service mysql start
        ```

3. 修改密码
    ```html
    mysql> use mysql
    mysql> update user set password=password('yourpassword') where user='root';
    mysql> flush privileges; 
    ```

4. 重新启动MySQL

    如果你上面**使用的是修改配置文件方式**，记得改回后再重启。
    
    ```html
    sudo service mysql restart
    ```


### 常见问题

#### 无法使用IP访问MySQL本地数据库
MYSQL数据库缺省安装后，其默认用户名ROOT如果只能以<localhost>或<127.0.0.1>方式访问主机，即通过外部IP地址访问返回如下内容：

    ERROR 1130 (): #HY000 Host 'XXXXXX' is not allowed to connect to this MySQL server
    
解决：

    GRANT ALL PRIVILEGES ON TABLE_NAME.* TO 'USER_NAME'@'%' IDENTIFIED BY 'USERS_PASSWORD';
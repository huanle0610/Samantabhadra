# php的运行场景

## 提供Web服务
### Apache + mod_php
### Nginx + PHP-FPM
![Apache Nginx 处理php差异](apache_nginx_php.puml)
### 其他
1. Apache worker + mod_fcgid
2. Apache worker + mod_fastcgi

## 命令行脚本
不需要Web服务器配合，写一个php文件执行就行了。

## 桌面应用程序
不常用


## 参考
[Apache mpm worker, prefork, mod_php mod_fcgid mod_fastcgi php-fpm and Nginx](http://t.cn/RqYr1Qf)
[]()
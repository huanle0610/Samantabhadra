#!/bin/bash
. lib.sh
render 'install rpm'
echo
yum install mysql-server php-mysql mysql mysql-devel* -y


render 'config the service of mysql'
echo 
service mysqld start
chkconfig mysqld on

render $(service mysqld status)
echo

render 'secure installation'
echo
promote 'Do you want to set mysql more secure?' 'fine' 'ok'
if [ $? == 0 ];then
    /usr/bin/mysql_secure_installation
fi


render 'test mysql'
echo
cmd='mysql -uroot -p -e "show databases;"'
echo $cmd
mysql -uroot -p -e "show databases;"

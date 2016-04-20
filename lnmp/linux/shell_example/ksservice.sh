#!/bin/bash
. lib.sh
service dhcpd restart
#启动dhcpd服务
chkconfig dhcpd on
#dhcpd服务开机自动启动
service httpd restart
#重启nfs服务
chkconfig httpd on
#nfs服务开机自动启动
service xinetd restart
#启动xinetd服务
chkconfig xinetd on
#xinetd服务开机自动启动

render 'Must has port tftp-69 dhcpd-67 httpd-80 ntp-123[option]'
print_line 2
# check tftp
netstat -lnp | grep 69

# check dhcpd 
netstat -lnp | grep dhcpd

# check httpd
netstat -lnp | grep 80 

# check ntp 
netstat -lnp | grep ntpd 

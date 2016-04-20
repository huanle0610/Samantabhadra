#!/bin/bash
. lib.sh
render close selinux
print_line 2
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

render close iptables
print_line 2
bash iptable_off.sh

render close NetworkManager   
print_line 2
chkconfig NetworkManager off
service NetworkManager stop

chkconfig network on 
service network start

chkconfig rpcbind on
service rpcbind start

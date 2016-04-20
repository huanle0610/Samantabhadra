#!/bin/bash
. lib.sh
#auto create eth0 static ip config file
#

if [ x$1 == x ]
then
	echo 'no ip set'
	exit 1
fi
eth0_cfg=/etc/sysconfig/network-scripts/ifcfg-eth0 
mac=`cat /sys/class/net/eth0/address`
ip=$1
segment=$_IP_PRE.
gw=${segment}1
dns=${segment}1


cat <<EOF > $eth0_cfg 
DEVICE=eth0
BOOTPROTO=static
HWADDR=${mac}
MTU=1500
NM_CONTROLLED=no
ONBOOT=yes
TYPE=Ethernet
IPADDR=${segment}${ip}
NETMASK=255.255.255.0
GATEWAY=${gw}
DNS1=${dns}
USERCTL=no
EOF

eth0_ip=$(current_ip eth0)
if [ $_IP != ${eth0_ip} ];then
	echo -n 'Curret eth0 ip is '
	warn $eth0_ip
	echo -n ' not ' 
	render $_IP
	echo 
	promote "Will restart network to change ip, maybe you will lost the connection. Continue? " 'ok' 'you did' 1
	service network restart
fi

#!/bin/bash
#设置静态IP
. lib.sh
#auto create eth0 static ip config file
#

if [ x$1 == x ]
then
	echo 'no ip set'
    ip=$(current_ip eth0 | awk -F. '{print $4}')
    if [ x$ip == x ];then
        warn 'not set ip and can not fetch one'
	    exit 1
    fi
else
    ip=$1
fi

eth0_cfg=/etc/sysconfig/network-scripts/ifcfg-eth0 
eth1_cfg=/etc/sysconfig/network-scripts/ifcfg-eth1 
mac=`cat /sys/class/net/eth0/address`
segment=${_IP_PRE}.
gw=${segment}1
dns=${segment}1
set_ip=${segment}${ip}


cat <<EOF > $eth0_cfg 
DEVICE=eth0
BOOTPROTO=static
HWADDR=${mac}
MTU=1500
NM_CONTROLLED=no
ONBOOT=yes
TYPE=Ethernet
IPADDR=${set_ip}
NETMASK=255.255.255.0
GATEWAY=${gw}
DNS1=${dns}
USERCTL=no
EOF

mac1=`cat /sys/class/net/eth1/address`
if [ $? -eq 0 ]; then

	ip1=$ip
	segment1=${_IP_PUB}.
	gw1=${segment1}1
	dns1=${segment1}1

	cat <<EOF > $eth1_cfg 
	DEVICE=eth1
	BOOTPROTO=static
	HWADDR=${mac1}
	IPV6INIT=yes
	MTU=1500
	NM_CONTROLLED=no
	ONBOOT=yes
	TYPE=Ethernet
	IPADDR=${segment1}${ip1}
	NETMASK=255.255.255.0
	GATEWAY=${gw1}
	DNS1=${dns1}
	USERCTL=no
EOF
fi
eth0_ip=$(current_ip eth0)
if [ $set_ip != ${eth0_ip} ];then
	echo -n 'Curret eth0 ip is '
	warn $eth0_ip
	echo -n ' not ' 
	render $set_ip
	echo 
	promote "Will restart network to change ip, maybe you will lost the connection. Continue? " 'ok' 'you did' 1
	service network restart
fi

render 'if list'
echo 
host_has_if eth0
host_has_if eth1

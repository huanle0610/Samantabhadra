#!/bin/bash
. lib.sh

render 'set hostname'
print_line 2

bash hostname.sh $_HOSTNAME $_NISDOMAIN


render 'set ip'
print_line 2

bash ifeth_ks.sh $_KS_IP 
host_has_if eth0
host_has_if eth1

yum install -y php php-common 
service httpd restart
render 'test web please'
print_line 2
promote "Can you open the url http://$_IP" "Great" "Check please" 1

render 'install tftp dhcp ... rpm'
print_line 2

yum install xinetd-*  tftp-server-* dhcp-* syslinux*


render 'config dhcp'
print_line 2
dhcp_cfg=/etc/dhcp/dhcpd.conf


cat <<EOF > $dhcp_cfg 
subnet ${_IP_PRE}.0
netmask 255.255.255.0 {
	option routers                  ${_IP_PRE}.1;
	option subnet-mask              255.255.255.0;
	option time-offset              -18000;
	range dynamic-bootp ${_IP_PRE}.10 ${_IP_PRE}.90;  #指定ip范围
	default-lease-time 21600;  # 默认租约时间
	max-lease-time 43200;  # 最大租约时间
	next-server     $_IP;   #指定 tftp服务器的ip
	filename        "pxelinux.0";  # 指定bootloader 文件的名字
}
EOF

render 'config tftp'
print_line 2
tftp_cfg=/etc/xinetd.d/tftp


cat <<EOF > $tftp_cfg 
service tftp
{
    socket_type             = dgram
    protocol                = udp
    wait                    = yes
    user                    = root
    server                  = /usr/sbin/in.tftpd
    server_args             = -u nobody -s /var/lib/tftpboot
    disable                 = no
    per_source              = 11
    cps                     = 100 2
    flags                   = IPv4
}
EOF



render 'prepare file'
print_line 2

bash preparetftpfile.sh

bash preparehttpdfile.sh


render 'start ntp service for time sync'
print_line 2
#ntpdate asia.pool.ntp.org ntp.sjtu.edu.cn
cp $DIR/etc/ntp.conf /etc/
chkconfig ntpd on 
service ntpd start


render 'start service'
print_line 2

bash ksservice.sh

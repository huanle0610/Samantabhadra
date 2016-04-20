#!/bin/bash
route add default gw 192.168.9.1 eth1
route del default gw 192.168.171.1 eth0
#route add default gw 192.168.171.1 eth0

cat >/etc/resolv.conf <<EOF
nameserver 192.168.9.1
nameserver 8.8.8.8
EOF

route

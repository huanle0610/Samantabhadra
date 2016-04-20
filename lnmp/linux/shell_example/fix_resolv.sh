#!/bin/bash
# 添加dns到配置文件
resolv_conf=/etc/resolv.conf 
grep '8.8.8.8' $resolv_conf > /dev/null
if [ 1 -eq $? ];then
    echo 'nameserver 8.8.8.8' > /tmp/resolv.tmp
    cat  /etc/resolv.conf   >> /tmp/resolv.tmp
    cat /tmp/resolv.tmp > /etc/resolv.conf
fi

cat $resolv_conf

#!/bin/bash
. lib.sh
cp $DIR/etc/idmapd.conf /etc/idmapd.conf
cp $DIR/etc/yp.conf /etc/yp.conf
cp $DIR/etc/nsswitch.conf /etc/nsswitch.conf
chkconfig ypbind on
service ypbind start
yptest
echo 
cat <<EOF
他会出现在passwd.byname当中找不到nobody的字样。这是因为早期的nobody之UID都设定在65534 ，但CentOS则将nobody设定为系统帐号的99 ，所以当然不会被记录，也就出现这一个警告。不过，这个错误是可忽略的啦！
Test 9: yp_all
List ALL User IS IMPORTANT
EOF

render 'User Home List'
echo
echo 'ls ' $_HOME_DIR
ls -al $_HOME_DIR

promote 'Are the owner of the directoris and files correct? ' 'great' 'opps, something is wrong'

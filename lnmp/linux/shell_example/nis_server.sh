#!/bin/bash
. lib.sh
render 'install rpm'
print_line 2
yum install ypserv.x86_64 ypbind.x86_64 yp-tools
render 'Check nis toos'
print_line 2
rpm -qa | grep '^yp'

ypservcfg=/etc/ypserv.conf
render "config $ypservcfg"
echo
cp $DIR$ypservcfg $ypservcfg 
last_status 'config success' 'config failure'

render "config /etc/idmapd.conf" 
echo
cp $DIR/etc/idmapd.conf /etc/idmapd.conf
last_status 'config success' 'config failure'

render 'cat /etc/hosts'
print_line 2
cat /etc/hosts

echo
render 'hostname and nisdomain'
print_line 2
print_hostname

promote "All above are all right "  "Great!"  "So, it is your turn" 1

#render 'Update /etc/hosts'
#print_line 2
#cp /etc/hosts $DIR/etc/hosts

render 'Update Client Config File'
print_line 2
myhostname=$(hostname)
mynisdomain=$(hostname --nis)
sed -i "s/\(_HOSTNAME=\).*/\1$myhostname/g;s/\(_NISDOMAIN=\).*/\1$mynisdomain/g;" ${DIR}/config.sh
for f in ${DIR}/etc_tpl/*
do
	render $f
	print_line 2
	to_file=${DIR}/etc/$(basename $f)
	render Update to $to_file
	print_line 2
	sed  "s/__HOSTNAME__/$myhostname/g;s/__NISDOMAIN__/$mynisdomain/g;" $f >$to_file
done


warn 'CREATE USER: THIS ACTION WILL DELETE USER HOME DIR'
promote 'Do you want create user for nis and others ?' 'ok' 'fine'
if [ $? == 0 ];then
    render 'creat user for nis'
    print_line 2
    echo
    bash create_user.sh
fi

render 'start nis service'
print_line 2
service ypserv start
service yppasswdd start

chkconfig ypserv on
chkconfig yppasswdd on

render 'init nis profiles'
print_line 2
/usr/lib64/yp/ypinit -m

render 'result'
print_line 2
rpcinfo -p localhost | grep 'yp'

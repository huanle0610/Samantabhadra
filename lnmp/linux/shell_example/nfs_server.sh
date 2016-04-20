#!/bin/bash
. lib.sh
render 'install rpm'
print_line 2
yum install -y nfs-utils nfs4-acl-tools portmap

render 'rpcbind must be is runing'
print_line 2
chkconfig --list | grep rpcbind
service rpcbind status | grep 'running'
last_status 'great' 'rpcbind is not runing, use  service rpcbind start'  1
echo

if [ ! -d $nfs_dir ];then
    
    warn "$nfs_dir is not exists" 
    promote 'Do you want create it ?' 'ok' 'you did it' 1
    mkdir $nfs_dir
fi

nfs_cfg=/etc/exports
render "config $nfs_cfg"
echo 
cat <<EOF > $nfs_cfg
$nfs_dir ${_IP_PRE}.0/24(rw)
EOF
render "See: $nfs_cfg"
echo 
cat $nfs_cfg 


render "service config"
echo 
chkconfig --list | grep rpcbind

service nfs start
service nfslock start

chkconfig nfs on
chkconfig nfslock on 

render "nfs reload /etc/export"
echo 
exportfs -arv


render 'nfs start list'
print_line 2
rpcinfo -t localhost nfs

render 'nfs export list'
print_line 2
showmount -e localhost

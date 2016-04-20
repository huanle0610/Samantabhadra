#!/bin/bash
. lib.sh

render 'rpcbind must be is runing'
print_line 2
chkconfig --list | grep rpcbind
service rpcbind status | grep 'running'
last_status 'great' 'rpcbind is not runing, use  service rpcbind start'  1

showmount -e $nfs_server

mkdir $nfs_dir

mount -t nfs $nfs_server:$nfs_dir $nfs_dir
render 'loaded nfs dir'
print_line 2
ls -al  $nfs_dir

grep "^$nfs_server:$nfs_dir" /etc/fstab 
if [ $? == 0 ];then
 	render "nfs dir has load in boot" 
else
	render 'Modify /etc/fstab'
	print_line 2
	echo  "$nfs_server:$nfs_dir  $nfs_dir  nfs   defaults        0 0" >>/etc/fstab  
	grep "^$nfs_server:$nfs_dir" /etc/fstab 
	echo 
fi

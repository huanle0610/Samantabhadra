#!/bin/bash
. lib.sh
ssh_dir=$DIR/ssh
promote 'Will delete all the file in ~/.ssh' 'Thank you' 'Ask your engineer,please' 1

rm -rf ~/.ssh/*
mkdir ~/.ssh
cp $ssh_dir/id_dsa ~/.ssh/id_dsa
cp $ssh_dir/authorized_keys ~/.ssh/authorized_keys
chown -R root.root ~/.ssh
chmod 600 ~/.ssh/id_dsa
chmod 644 ~/.ssh/authorized_keys
#confirm selinux
restorecon -R -v ~/.ssh

render 'SElinux Status'
print_line 2
sestatus

render "List SSH Key"
print_line 2
ls -alZ ~/.ssh


ssh-keyscan -t rsa  $_HOSTNAME > /root/.ssh/known_hosts

promote 'Do not you want test ssh? [y/n] ?' 'ok' 'fine'
if [ $? == 1 ];then
    render "Test SSH Key"
    print_line 2
    ssh $_HOSTNAME
fi

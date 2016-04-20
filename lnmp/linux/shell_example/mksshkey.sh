#!/bin/bash
#创建ssh key
. lib.sh
render 'list ~/.ssh'
print_line 2
ls -al ~/.ssh

promote 'Do you want to create new key pair?' 'ok'  'fine'
if [ $? == 0 ];then
    ssh-keygen -b 1024 -t dsa -C 'My Cluster Manage KEY'
    cat ~/.ssh/id_dsa.pub >>  ~/.ssh/authorized_keys
fi

chmod 700 ~
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_dsa
chmod 644 ~/.ssh/authorized_keys
#confirm selinux
restorecon -R -v ~/.ssh

cp ~/.ssh/id_dsa $DIR/ssh/
cp ~/.ssh/authorized_keys $DIR/ssh/
render 'List SSH Key'
print_line 2
ls $DIR/ssh/


render 'test ssh localhost'
echo 
ssh localhost

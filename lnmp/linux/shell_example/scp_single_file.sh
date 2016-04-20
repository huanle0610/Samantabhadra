#!/bin/bash
. lib.sh

scpheader=root@$_HOSTNAME:
render 'update /etc/hosts'
echo
_file=/etc/hosts 
scp $scpheader$_file $_file

render 'update /root/.rhosts'
echo
_file=/root/.rhosts 
scp $scpheader$_file $_file

render 'update /etc/hosts.equiv'
echo
_file=/etc/hosts.equiv
scp $scpheader$_file $_file

render 'update /root/.ssh/known_hosts'
echo
_file=/root/.ssh/known_hosts
scp $scpheader$_file $_file

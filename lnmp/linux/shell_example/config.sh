#!/bin/bash
# ISO and DVD repo
_isopath=/var/dvd/rhel64_x86_64.iso 
_dvdtarget=/media/dvd

#NISDOMAIN
_NISDOMAIN=(none)

# NIS SERVER HOST
_HOSTNAME=myserver

#NFS
nfs_server=$_HOSTNAME
nfs_dir='/mydb'

# ks ip
_KS_IP=157

_IP_PUB=110.24.79
# NIS SEVER IP
_IP_PRE=10.19.119
_IP=${_IP_PRE}.$_KS_IP

_USERS=( "bing")
_PASS='123123'
_HOME_DIR='/home/'
_USER_SHELL='/bin/bash'
_START_UID=800


# www-php
_WWW_PHP=/html/cfg/php

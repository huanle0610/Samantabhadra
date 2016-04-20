#!/bin/bash
. lib.sh
render 'install rpm'
echo
yum install yum install tigervnc-server  -y


render 'how to add user ?'
print_line 2
cat <<EOF
su lzj
vncpasswd
ls -al ~/.vnc
EOF
print_line 2

echo
promote 'Do you have add some user to vnc?' 'ok' 'try again' 1

vncserver_cfg=/etc/sysconfig/vncservers
render 'how to config ' $vncserver_cfg  ?
echo

print_line 2
cat <<EOF
## Single user like this ##
VNCSERVERS="2:lzj"
VNCSERVERARGS[2]="-geometry 1600x900"

## Multiple Users ##
VNCSERVERS="2:ravi 3:navin 4:avishek"
VNCSERVERARGS[2]="-geometry 1280x1024"
VNCSERVERARGS[3]="-geometry 1280x1024"
VNCSERVERARGS[4]="-geometry 1280x1024"
EOF
print_line 2

render 'tail '$vncserver_cfg
print_line 2
tail $vncserver_cfg
promote 'Are you sure these correct?' 'ok' 'try again' 1

render 'config the service of vncserver'
echo 
service vncserver start
chkconfig vncserver on

render $(service vncserver status)
echo

render 'vncserver list is running' 
echo
ps -ef | grep vnc

render 'test'
print_line 2
cat <<EOF
you can download software from :
http://www.realvnc.com/download/

use address like this: `render $(current_ip eth0):1` 
to test
good luck!
EOF
print_line 2


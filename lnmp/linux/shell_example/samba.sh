#!/bin/bash
#安装samba
. lib.sh



yum install samba samba-client

render 'check samba config'
echo
testparm

render 'config the service of samba'
sevice samba start
chkconfig samba on


# create systems user

# 
render 'Current User List'
echo 
pdbedit -L



# add User to Samba
cat <<EOF
you can add user like this:
# pdbedit -a -u lzj
EOF


render 'Current User List'
echo 
pdbedit -L


service smb restart

render 'Test Anonymous login'
echo 
smbclient -L //localhost

render 'Test User login'
echo 
smbclient -L //localhost -U lzj

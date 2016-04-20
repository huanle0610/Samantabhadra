#!/bin/bash
#include bash library
. lib.sh
paramters=$@

show_help(){
render Usage:
echo 
		cat <<End-of-message
	bash $0
Tip: YOU MUST DO THE UNDER BEFORE!!

   # mkdir /media/dvd

   How to mount the DVD?
   find dvd device:  
	# dmesg | grep --color -A3  'DVD\|CD' 
	# mount /dev/sr1 /media/dvd

   Also, you can use iso replace dvd
   use iso
        # mount -t iso9660 /var/dvd/rhel64_x86_64.iso /media/dvd -o loop
	
	You can also use 
		# bash mount_iso.sh

  How to create ISO from DVD?
	dd if=/dev/cdrom of=/var/dvd/rhel64_x86_64.iso
End-of-message
print_line 

}
ls ${_dvdtarget}/isolinux
if [ $? != 0 ];then
	show_help
	exit 1
fi

dvdrepo=/etc/yum.repos.d/dvd.repo 
cat <<EOF > $dvdrepo 
[dvd]
name=RHEL- \$releasever - \$basearch - SourceDVD
baseurl=file://${_dvdtarget}/
gpgcheck=0
enabled=1
EOF
render $dvdrepo
print_line 2
cat  $dvdrepo

print_line
render "repo list"
print_line 2
yum repolist all

render "test repo"
print_line 2
yum search yp | grep NIS
print_line

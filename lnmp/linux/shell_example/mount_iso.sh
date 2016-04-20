#!/bin/bash
# mount ISO 到配置的路径
. lib.sh

isopath=$_isopath
dvdtarget=$_dvdtarget

if [ -e "$dvdtarget/isolinux" ];then
	render "You have load the iso correctly!" 
	echo 
	exit 0
else
	if [ ! -e "$isopath" ];then
		warn "Please put the RHEL6.4's ISO here: $isopath"
		echo 
	fi
	
	mount -t iso9660 $isopath $dvdtarget -o loop
fi
ls $dvdtarget/isolinux > /dev/null 
last_status 'Mount ISO Successful' 'Mount ISO Failture' 

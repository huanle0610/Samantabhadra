#!/bin/bash
# 收集系统信息： 系统名、内存、CPU等
. lib.sh

# Detects which OS and if it is Linux then it will detect which Linux Distribution.

OS=`uname -s`
REV=`uname -r`
MACH=`uname -m`

GetVersionFromFile()
{
       VERSION=`cat $1 | tr "\n" ' ' | sed s/.*VERSION.*=\ // `
}

if [ "${OS}" = "SunOS" ] ; then
       OS=Solaris
       ARCH=`uname -p`
       OSSTR="${OS} ${REV}(${ARCH} `uname -v`)"
elif [ "${OS}" = "AIX" ] ; then
       OSSTR="${OS} `oslevel` (`oslevel -r`)"
elif [ "${OS}" = "Linux" ] ; then
       KERNEL=`uname -r`
       if [ -f /etc/redhat-release ] ; then
               DIST='RedHat'
               PSUEDONAME=`cat /etc/redhat-release | sed s/.*\(// | sed s/\)//`
               REV=`cat /etc/redhat-release | sed s/.*release\ // | sed s/\ .*//`
       elif [ -f /etc/SuSE-release ] ; then
               DIST=`cat /etc/SuSE-release | tr "\n" ' '| sed s/VERSION.*//`
               REV=`cat /etc/SuSE-release | tr "\n" ' ' | sed s/.*=\ //`
       elif [ -f /etc/mandrake-release ] ; then
               DIST='Mandrake'
               PSUEDONAME=`cat /etc/mandrake-release | sed s/.*\(// | sed s/\)//`
               REV=`cat /etc/mandrake-release | sed s/.*release\ // | sed s/\ .*//`
       elif [ -f /etc/debian_version ] ; then
               DIST="Debian `cat /etc/debian_version`"
               REV=""

       fi
       if [ -f /etc/UnitedLinux-release ] ; then
               DIST="${DIST}[`cat /etc/UnitedLinux-release | tr "\n" ' ' | sed s/VERSION.*//`]"
       fi

       OSSTR="${OS} ${DIST} ${REV}(${PSUEDONAME} ${KERNEL} ${MACH})"

fi

render os info
echo
echo ${OSSTR} 
echo -n 'CPU: '
grep "model name" /proc/cpuinfo | awk -F: '{print $2}'
echo -n 'hostname: ' 
render $(hostname)
echo
dmidecode | grep 'BIOS Information' -A3''
echo

current_hwaddr(){
    ifconfig $i | grep HWaddr | awk '{print $5}'
}

render interface 
echo
printf "%12s\t%12s\t%s" if ip addr
print_line 2
for i in  `cat /proc/net/dev | grep '.:' | awk -F: '{print $1}'`; do 
    cip=`current_ip $i`
    caddr=`current_hwaddr $i`
    printf "%12s\t%12s\t%s" $i $cip $caddr
    echo
done
echo

render cpu cores
echo
nproc
echo


render cpu info 
echo
lscpu
echo


render memory 
echo
echo -n "Memory Total: "
grep MemTotal /proc/meminfo | awk '{print $2}'
grep MemTotal /proc/meminfo | awk '{print $2/1024"M"}'
echo -n "Swap Total: "
grep SwapTotal /proc/meminfo | awk '{print $2}'
grep SwapTotal /proc/meminfo | awk '{print $2/1024"M"}'
echo

render storage
echo
lsblk
echo

render df 
echo
#df -h
df -hx tmpfs
echo

render mount info
echo
mount -l | grep ' ext\| iso\| vmhgfs\| vfat'
echo

render fdisk 
echo
fdisk -l
echo

render route 
echo
route
echo

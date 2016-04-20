#!/bin/bash
. lib.sh
mkdir /var/www/html/ks

cfgfile=/var/www/html/ks/ks.cfg

cat <<EOF > $cfgfile
#platform=x86, AMD64, or Intel EM64T
#version=DEVEL
# Firewall configuration
firewall --disabled
# Install OS instead of upgrade
install
# Use network installation
url --url="http://$_IP/dvd"
# Root password
rootpw --iscrypted \$1\$FKUq/IAG\$DTuApDQoeH4c4YibfyKbb0
# System authorization information
auth  --useshadow  --passalgo=sha512
# Use cmdline mode install
cmdline
firstboot --disable
# System keyboard
keyboard us
# System language
lang en_US
# SELinux configuration
selinux --disabled
# Installation logging level
logging --level=info
# Reboot after installation
reboot
# System timezone
timezone  Asia/Shanghai
# Network information
network  --bootproto=dhcp --device=eth0 --onboot=on
# System bootloader configuration
bootloader --location=mbr
# Clear the Master Boot Record
zerombr
# Partition clearing information
clearpart --all --initlabel 
part / --grow --size=5000
part /boot --recommended --size=512
part swap --recommended

%post --log=/root/ks-post.log
set -x
#!/bin/sh
### mount config dir
mkdir $nfs_dir
mount -t nfs -o ro,nolock,udp $_IP:$nfs_dir $nfs_dir 
ls $nfs_dir

cat << EOG > /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4 
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

$_IP $_HOSTNAME 
EOG

date
(
cat << 'EOCC' 
#!/bin/bash
echo 'hi'
date
cd /root 
rm -rf cfg
wget -O cfg.tar.bz2 http://$_IP/cfg.tar.bz2
tar xf cfg.tar.bz2
cd cfg
bash init_first.sh
sed  -i '/firstboot.sh/d' /etc/rc.local
EOCC
) > /root/firstboot.sh

cat >> /etc/rc.local <<'EOG'
# first install 
bash /root/firstboot.sh
EOG

cat << 'EOG' > /etc/resolv.conf
    nameserver 8.8.8.8 
    nameserver $_IP 
EOG

%end

%packages
@additional-devel
@backup-client
@backup-server
@base
@basic-desktop
@chinese-support
@cifs-file-server
@compat-libraries
@console-internet
@debugging
@desktop-platform
@desktop-platform-devel
@development
@dial-up
@directory-client
@directory-server
@fonts
@ftp-server
@general-desktop
@graphical-admin-tools
@hardware-monitoring
@identity-management-server
@infiniband
@input-methods
@java-platform
@large-systems
@legacy-unix
@legacy-x
@mainframe-access
@mysql
@mysql-client
@network-file-system-client
@network-server
@network-tools
@nfs-file-server
@performance
@perl-runtime
@php
@postgresql
@postgresql-client
@print-client
@print-server
@remote-desktop-clients
@ruby-runtime
@scientific
@security-tools
@server-platform
@server-platform-devel
@smart-card
@storage-client-fcoe
@storage-client-iscsi
@storage-client-multipath
@storage-server
@system-admin-tools
@system-management
@system-management-messaging-client
@system-management-snmp
@system-management-wbem
@turbogears
@virtualization
@virtualization-client
@virtualization-platform
@virtualization-tools
@web-server
@x11
cjkuni-fonts-ghostscript
compat-openmpi
compat-openmpi-psm
crypto-utils
hmaccalc
mod_revocator
samba

%end
EOF

ln -sf $_dvdtarget /var/www/html/

render 'ls /var/www/html'
echo 
ls -al /var/www/html
print_line 2

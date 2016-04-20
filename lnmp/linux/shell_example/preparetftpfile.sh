#!/bin/bash
. lib.sh
cp /usr/share/syslinux/pxelinux.0 /var/lib/tftpboot/
cp $_dvdtarget/images/pxeboot/{vmlinuz,initrd.img} /var/lib/tftpboot/

mkdir /var/lib/tftpboot/pxelinux.cfg

tftp_cfgdir=/var/lib/tftpboot
tftp_cfgfile=/var/lib/tftpboot/pxelinux.cfg/default

cat <<EOF > $tftp_cfgfile
default linux
label linux
  kernel vmlinuz
  append initrd=initrd.img ks=http://$_IP/ks/ks.cfg ksdevice=eth0
EOF

render 'ls ' $tftp_cfgdir
echo 
ls -al $tftp_cfgdir 
print_line 2

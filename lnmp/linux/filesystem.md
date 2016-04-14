#文件系统
**一切皆文件**
"On a UNIX system, everything is a file; if something is not a file, it is a process."
图片是文件
文本是文件
程序是文件
设备也文件

## 文件类型
常见类型： 普通文件(-)、目录文件(d)、字符设备文件(c)和块设备文件(b)、链接文件等
还有 pipe socket...
[演示] ll -al
total 12
drwxr-xr-x   2 root root 4096 Apr 15 00:24 .
dr-xr-x---. 37 root root 4096 Apr 15 00:07 ..
lrwxrwxrwx   1 root root    5 Apr 15 00:23 a1.txt -> a.txt
**-rw-r--r--**   1 **root** **root**    4 Apr 15 00:04 a.txt

## 文件权限
**-rw-r--r--**   1 **root** **root** a.txt
1+3(Owner权限) + 3(Group权限) + 3(Other权限) = 10位

r(Read)w(Write)x(execute)

x对文件是可执行；对目录是可进入

chmod  -change file mode bits
chown  -change file owner and group
chgrp  -change group ownership

----------------

[演示] echo 124 > a.txt # 写124 到文件a.txt
[演示] ls
a.txt
[演示] cat a.txt       # 查看a.txt 的内容
124
[演示] echo 124 > /dev/stdin
124

[演示] file /dev/stdin
/dev/stdin: symbolic link to '/proc/self/fd/0'
[演示] file a.txt
a.txt: ASCII text
[演示] mv a.txt a.jpg
[演示] ll a.*
-rw-r--r-- 1 root root 4 Apr 15 00:04 a.jpg
[演示] file a.jpg
a.jpg: ASCII text
[演示] file /proc/self/fd/0
/proc/self/fd/0: symbolic link to '/dev/pts/0'
[演示] file /dev/pts/0
/dev/pts/0: character special
[演示] file /dev/shm/
/dev/shm/: sticky directory

[演示] ls -al /dev/xvda1
brw-rw---- 1 root disk 202, 1 Mar 10 01:01 /dev/xvda1

## 扩展名
在Windows底下， 能被执行的文件扩展名通常是 .com .exe .bat等等，
而在Linux底下，只要你的权限当中具有x的话，例如[ -rwx-r-xr-x ] 
即代表这个文件可以被执行。
不过，可以被执行跟可以执行成功是不一样的～

## 目录树
ls 
bin   dev   home  lib64       media  opt   root  selinux  sys  usr
boot  etc   lib   lost+found  mnt    proc  sbin  srv      tmp  var


![目录树](http://tldp.org/LDP/intro-linux/html/images/FS-layout.png "目录树")

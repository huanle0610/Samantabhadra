# so

```html
[root@aladin cfg]# ls -lh /bin/ln /sbin/sln
-rwxr-xr-x 1 root root  49K Jun 25  2014 /bin/ln
-rwxr-xr-x 1 root root 671K Jan 28  2015 /sbin/sln
[root@aladin cfg]# ldd /sbin/sln 
	not a dynamic executable
[root@aladin cfg]# ldd /bin/ln
	linux-vdso.so.1 =>  (0x00007fff4cbff000)
	libc.so.6 => /lib64/libc.so.6 (0x0000003e43400000)
	/lib64/ld-linux-x86-64.so.2 (0x0000003e43000000)
[root@aladin cfg]# 
```



```html
[root@aladin cfg]# ldconfig -p | grep '/lib64/libc.so.6'
	libc.so.6 (libc6,x86-64, OS ABI: Linux 2.6.18) => /lib64/libc.so.6
[root@aladin cfg]# ldconfig -p | grep '/lib64/ld-linux-x86-64.so.2'
	ld-linux-x86-64.so.2 (libc6,x86-64) => /lib64/ld-linux-x86-64.so.2
```

```html
ldd - print shared library dependencies
       ldd  prints  the shared libraries required by each program or shared library specified on the command line.
       
/sbin/ldconfig - configure dynamic linker run-time bindings
        -p     Print the lists of directories and candidate libraries stored in the current cache.

```
# Zip a file without compression

```shell
[root@aladin ~]# zip -r -0 1109_0.zip 1109.txt
  adding: 1109.txt (stored 0%)
[root@aladin ~]# zip -r -1 1109_1.zip 1109.txt
  adding: 1109.txt (deflated 68%)
[root@aladin ~]# zip -r -9 1109_9.zip 1109.txt
  adding: 1109.txt (deflated 73%)
```

- Result

```shell
[root@aladin ~]# ll
total 104
-rw-r--r--  1 root root 10192 Nov  9  2014 1109.txt
-rw-r--r--  1 root root 10358 Aug 24 21:04 1109_0.zip
-rw-r--r--  1 root root  3440 Aug 24 21:04 1109_1.zip
-rw-r--r--  1 root root  2885 Aug 24 21:05 1109_9.zip
```
man zip

       -#
       (-0, -1, -2, -3, -4, -5, -6, -7, -8, -9)
              Regulate the speed of compression using the specified digit #, where  -0  indicates
              no  compression (store all files), -1 indicates the fastest compression speed (less
              compression) and -9 indicates the slowest compression speed  (optimal  compression,
              ignores the suffix list). The default compression level is -6.

              Though  still  being worked, the intention is this setting will control compression
              speed for all compression methods.  Currently only deflation is controlled.

    -r
       --recurse-paths
              Travel the directory structure recursively; for example:
 
                     zip -r foo.zip foo

              or more concisely

                     zip -r foo foo

              In this case, all the files and directories in foo are saved in a zip archive named
              foo.zip, including files with names starting with ".", since the recursion does not
              use  the  shell?.  file-name substitution mechanism.  If you wish to include only a
              specific subset of the files in directory foo and its subdirectories,  use  the  -i
              option  to specify the pattern of files to be included.  You should not use -r with
              the name ".*", since that matches ".."  which will attempt to  zip  up  the  parent
              directory (probably not what was intended).

              Multiple source directories are allowed as in

                     zip -r foo foo1 foo2

              which first zips up foo1 and then foo2, going down each directory.

              Note  that while wildcards to -r are typically resolved while recursing down direc-
              tories in the file system, any -R, -x, and -i wildcards  are  applied  to  internal
              archive  pathnames  once  the  directories are scanned.  To have wildcards apply to
              files in subdirectories when recursing on Unix and similar systems where the  shell
              does  wildcard  substitution, either escape all wildcards or put all arguments with
              wildcards in quotes.  This lets zip see the wildcards and match files in  subdirec-
              tories using them as it recurses. 

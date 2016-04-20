#!/bin/bash
# 生成随机密码
i=1 
if [ x$1 == x ];then
    n=30
else
    n=$1
fi
printf "%04s\t%s\n" 'Tool' 'Power by aladin' >passwd.txt 
printf "%04s\t%s\n" '----' '---------------' >>passwd.txt 
while [ $i -le $n ];do 
    ls mkpasswd  > /dev/null 2>&1
    if [ $? -eq 0 ];then
        /usr/bin/mkpasswd -l 32 -d 5 -C 5 >>passwd.txt 
    else
        printf "%04d\t%s\n" $i $(</dev/urandom tr -dc '12344!@#$%qwertQWERTasdfgASDFGzxcvbZXCVB' | head -c32; echo "") >> passwd.txt
    fi
    let i+=1 
done 
exit 0

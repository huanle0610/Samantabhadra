#!/bin/bash
# 列出指定目录中大小超过给定值的文件（目录）列表（第一层）
#set -x
if [ $1 == 'raw' ];then
    raw=1
else
    raw=0
    if [ '-h' == $1 ];then
        cat <<EOF
        $0 raw[noraw] 1024[ as maxsize ] config_file_path[ or 0 ]
        eg:
        bash storage_stat.sh noraw 1
        bash storage_stat.sh noraw 1024 list_file.conf /var/www
        bash storage_stat.sh noraw 1024 0 /var/www
        bash storage_stat.sh noraw 1024 stat.conf /var/www 1>/tmp/file_size.txt 2>&1
EOF
        exit 0
    fi
fi

if [ ! -z $2  ];then
    size=$2
else
    size=5
fi

if [ ! -z $3  ];then
    config_file=$3
else
    config_file=0
fi
line(){
    echo 
    echo --------------------
    echo 
}
gettype(){
    test -d $1 && echo d # dir
    test -b $1 && echo b # like /dev/sda 
    test -c $1 && echo c # like dev/tty1 
    test -f $1 && echo f # common file
    test -L $1 && echo L  && readlink -e $1 # link
}
stat(){
    if [ ! -z $1 -a -e $1 ]; then
        gettype $1
        echo $1
        if [ $raw == 1 ];then
             du --max-depth=1 -akL $1 | sort -rn|awk -vsize=$size '{if($1 >= size){printf "%16.0f ----> %s\n",$1,$2}}'|sed 's:/.*/\([^/]\{1,\}\)$:\1:g' 
        else
             du --max-depth=1 -akL $1 | sort -rn|awk -vsize=$size '{if($1 >= size){printf "%7.2fM ----> %s\n",$1/1024,$2}}'|sed 's:/.*/\([^/]\{1,\}\)$:\1:g'
        fi
    else
        echo process $1 error
    fi
}

date "+%Y-%m-%d %H:%M:%S%n%s"
echo Total
line
df -h 
line

for i in ${@:4}
do
    stat $i
    line
done

# use config
# one line is dir path
test -f $config_file && 
while read line; do    
    stat $line
    line
done < $config_file || echo no config file 

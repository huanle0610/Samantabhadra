#!/bin/bash
# 指定时间间隔观测一个进程的变化
#set -x 
if [ "$#" -ne 2 ]
then
  echo "Usage: watch_pstree.sh PID INTERVAL 
    eg: bash watch_pstree.sh 2338 2
    # bash watch_pstree.sh 2338 2 | tee 2338.txt"
  exit 1
fi

count=1
pid=$1
interval=$2

pid_alive(){
    ps -p $1 > /dev/null 2>&1
    return  $?   
}

while true
do
    pid_alive $pid 

    if [ 0 == $? ];then
        echo $count
        echo ====== 
        #pstree -p $pid
        pstree -plan $pid
    else
        echo pid $pid has gone away.
        break
    fi 

    count=$[$count + 1]
    sleep $interval
done

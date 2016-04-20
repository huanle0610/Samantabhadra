#!/bin/bash
. lib.sh
log_dir=log/
log_file=$log_dir`hostname`'_'`date "+%Y%m%d_%H%M%S"`'.txt'

rm $log_dir`hostname`*.txt
bash sysinfo.sh | tee $log_file
render log into file
echo
echo $log_file
ls -l $log_file

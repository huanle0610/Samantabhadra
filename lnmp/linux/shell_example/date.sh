#!/bin/bash
. lib.sh
render 'Date format example'
print_line 2

a='date "+%Y-%m-%d"' 
render $a
eval $a

(cat <<EOF 
date "+%Y-%m-%d %H:%M:%S"
date "+%Y_%m_%d %H:%M:%S"
date "+%Y-%m-%d"
date "+%H:%M:%S"
date -d tomorrow
date -d yesterday 
EOF
) | while read i j; 
do 
    render $i $j
    echo -n "  " 
    eval $i $j
done

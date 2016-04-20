#!/bin/bash
#include bash library
. lib.sh

print_line
render "super dameon status on"
print_line 2
grep -i 'disable' /etc/xinetd.d/* | grep no | awk -F: '{print $1}'

render "stand alone dameon on"
print_line 2
chkconfig --list | grep '3:on\|5:on\|\son'


render "runing now list"
print_line 2
service --status-all | grep running | awk 'BEGIN{printf "%-15s | %s\n--- ---\t\t --- ---\n", "Dameon", "pid list"; }{printf "%-15s | %s\n",$1, gensub("[0-9]+", "", gsub("[^0-9]+", " ", $0))}'

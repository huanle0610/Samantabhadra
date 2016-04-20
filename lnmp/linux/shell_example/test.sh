#!/bin/bash
. lib.sh
render $(current_ip eth0)
echo
test -z $1 && echo hi

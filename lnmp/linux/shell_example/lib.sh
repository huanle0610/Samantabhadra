#!/bin/bash
# 自定义库文件
. config.sh

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
cd $DIR

#echo $SOURCE
#echo $DIR
#pwd

# Text color variables
txtred='\e[0;31m'       # red
txtgrn='\e[0;32m'       # green
txtylw='\e[0;33m'       # yellow
txtblu='\e[0;34m'       # blue
txtpur='\e[0;35m'       # purple
txtcyn='\e[0;36m'       # cyan
txtwht='\e[0;37m'       # white
bldred='\e[1;31m'       # red    - Bold
bldgrn='\e[1;32m'       # green
bldylw='\e[1;33m'       # yellow
bldblu='\e[1;34m'       # blue
bldpur='\e[1;35m'       # purple
bldcyn='\e[1;36m'       # cyan
bldwht='\e[1;37m'       # white
txtund=$(tput sgr 0 1)  # Underline
txtbld=$(tput bold)     # Bold
txtrst='\e[0m'          # Text reset

# Feedback indicators
info=${bldwht}*${txtrst}
pass=${bldblu}*${txtrst}
warn=${bldred}!${txtrst}

render (){
	for var in "$@"
	do
	    echo -ne "${txtgrn}${txtbld}${var}${txtrst} " 
	done
}

warn(){
	for var in "$@"
	do
            echo -ne "${txtred}${var}${txtrst} " 
	done
}

print_hostname () {
	echo -n 'Current Hostname: '
	render `hostname` 
	echo
	echo -n 'Current nisdomain: '
	render `hostname --nis` 
	echo
}

last_status() {
	if [ $? -eq 0 ];then 
		render $1;
	        [ $# == 2 ] && echo
		return 0
	else 
		warn $2;
	        [ $# == 2 ] && echo
		return 1
	fi
}

require_parameter(){
	order=1
	need=$(( $1 + 2 ))
	given=0

	for var in "$@"
	do
#	    warn $order,'---', $var
	    if [ $order == $need ];then
		given=1
		break
	    fi
	    ((order++))
	done

	if [ $given == 0 ];then
		warn $2
		echo 
		return 1
	fi
	return 0
}

print_line(){
    if [ "$#" -eq 1 ]; then 
		bit=$1 
	else 
		bit=0
	fi

	getbit $bit 1
    if [ $? == 1 ];then echo ; fi
	echo '------------------------------------------'
	getbit $bit 0
        if [ $? == 1 ];then echo ; fi
}

getbit(){
    return $(( ($1 >> $2) & 0x01 ))
}

#  promote "All above are all right "  "Great!"  "So, I must check them in time." 1
promote(){
    if [ x$_read_dis != x ];then
        echo "$1(y/n)? [y]"
        CONT=y
    else
        read -p "$1 (y/n)? " CONT
    fi  
    if [ "$CONT" == "y" ]; then
      render $2
      echo
      return 0
    else
      warn $3  
      echo
      if [ $# == 4 ];then
        if [ $4 -eq 1 ];then
            exit 1
        fi  
      fi  
      return 1
    fi  
}

current_ip(){
	ifconfig  $1 |sed -n '2p'|awk '{print $2}'|cut -c 6-30
}

if_list(){
	render 'network interface list'
	print_line 2
	cat /proc/net/dev | grep '.:' | awk -F: '{print $1}'
}

host_has_if(){
	echo -n 'Dose host has network interface ' 
	render "$1?"
	cat /proc/net/dev | grep '.:' | awk -F: '{print $1}' | grep $1 > /dev/null
	last_status 'Yes'  'No' 'no new line'
	if [ $? == 0 ];then
		echo  -n "    IP: "
		render $(current_ip $1)
	fi
	echo
}

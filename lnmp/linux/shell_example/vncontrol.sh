#!/bin/bash
. lib.sh
# customize with your own.





options=(
"#clear"
"#quit"
"#update_nodes_time"
"#list_vnc" 
"#hostname" 
"#mount_iso" 
"#start_novnc"
'#show_config'
)

start_with(){
    echo $1 | grep '^'$2 >/dev/null 2>&1
    echo $?
}

is_func(){
    cmd=$1 
    [ "${options[$1]}" -a  0 == "$(start_with "${options[$1]}" '#')" ] && cmd=$( echo ${options[$1]} | awk -F# '{print $2}')
    type func_$cmd 2>/dev/null | grep 'is a function' > /dev/null 2>&1
    ret=$?
    if [ $ret == 0 -a x$2 != x ];then 
        func_$cmd 
    else
        return $ret
    fi
}

func_clear(){
    clear
    echo 'clear...'
}

func_quit(){
   exit 
}

func_update_nodes_time(){
    cexec "ntpdate asia.pool.ntp.org ntp.sjtu.edu.cn"
}

func_hostname(){
    hostname
}

func_mount_iso(){
    bash mount_iso.sh
}

func_list_vnc(){
    vncserver -list
}

func_show_config(){
    cat /etc/sysconfig/vncservers  | grep '^[^#]'
}

func_start_novnc(){
    cat <<OEF

    cd ~/cfg/noVNC/utils/;./launch.sh --listen 6080 --vnc localhost:5903 > /dev/null 2>&1

    OR

    cd ~/cfg/noVNC/utils/;./launch.sh --listen 6080 --vnc localhost:5903 
OEF
}

menu() {
    render "Avaliable options:"
    echo
    for i in ${!options[@]}; do 
        printf "%3d%s) %s\n" $((i+1)) "${choices[i]:- }" "${options[i]}"
    done
    [[ "$msg" ]] && echo "$msg"; :
}

prompt="Check an option (again to uncheck, ENTER when done): "
while menu && read -rp "$prompt" num && [[ "$num" ]]; do
    [[ "$num" != *[![:digit:]]* ]] && (( num > 0 && num <= ${#options[@]} )) || {
        msg="Invalid option: $num"; continue
    }
    ((num--)); 
    msg="${options[num]} was ${choices[num]:+un}checked"
    [[ "${choices[num]}" ]] && choices[num]="" || choices[num]="+"
    render 'command result:'
    echo
    warn '##########################################'
    print_line 2
    echo
    is_func $num 1
    print_line 2
    warn '##########################################'
    echo
done

printf "You selected"; msg=" nothing"
for i in ${!options[@]}; do 
    [[ "${choices[i]}" ]] && { printf " %s" "${options[i]}"; msg=""; }
done

echo $num
echo "$msg"

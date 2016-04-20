#!/bin/bash
#批量创建用户
#include bash library
. lib.sh
#set -x

num_rows=4
num_columns=5

f1="%$((${#num_rows}+1))s"
f2=" %9s"
f3=" %16s"

homedir=$_HOME_DIR
usershell=$_USER_SHELL
setpwd=$_PASS
userpwd=$(echo ${setpwd} | openssl passwd -1 -stdin)
cols=( "uid" "group" "home" "shell" "passwd" "username" )
startuid=$_START_UID

#            useradd -u 12345 -g $_USERS -d /home/username -s /bin/bash -p $(echo mypasswd | openssl passwd -1 -stdin) username
useradd_tpl="useradd -u %s -g %s -d ${homedir}%s -s ${usershell} -p ${userpwd} %s"

#for i in "${cols[@]}"
#	do 
#    		printf "$f3" $i
#	done
#echo 

for i in "${_USERS[@]}"
	do 
		#rm -rf ${homedir}${i}		
		userdel ${i}
		groupdel ${i}

		if [ -d "$homedir" ];then
			echo $homedir exists	
		else
			echo $homedir not exists,And I will create that.	
			mkdir -p ${homedir}
			last_status "Create ${homedir} successfully" "Create Dir failure"
		fi
    		useradd_cmd=`printf "$useradd_tpl" $startuid $i $i $i` 
		echo $useradd_cmd
		groupadd ${i}
		last_status "Create  Group ${i} successfully" "Create Group ${i} failure"
		$($useradd_cmd)
		last_status "Create User ${i} successfully" "Create User ${i} failure"
        chown -R ${i}.${i} ${homedir}$i
		((startuid++))
	done
echo 

#for ((i=1;i<=num_rows;i++)) do
#    printf "$f3" $i
#done
echo

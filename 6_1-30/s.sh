#!/bin/sh
#
#1、向系统中添加20个用户，名字为linuxer1-linuxer20，密码分别为其用户名，要使用while循环；
#2、要求：在添加每个用户之前事先判断用户是否存在，如果已经存在，则不再添加此用户；
#3、添加完成后，显示linuxer1-linuxer20每个用户名及对应的UID号码和GID号码，形如
#   stu1, UID: 1000, GID: 1000  (此步要求使用awk实现)
id|grep root &>/dev/null 
[ $? -ne 0 ] && echo "should be root user" && exit 1
for user in linuxer{1..20};do
    grep $user /etc/passwd &>/dev/null
    if [ $? -ne 0 ];then
	useradd $user
	echo $user:$user | chpasswd
	grep $user /etc/passwd | awk -F: '{printf "%s,UID:%d,GID:%d\n", $1,$3,$4}'
    fi
done


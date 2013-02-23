#!/bin/sh
#
#1、要求用户从键盘输入一个用户名，判断此用户是否存在，如果存在，则返回此用户的默认shell；如果不存在，提示用户不存在。
#2、判断完成以后不要退出脚本，而是继续提示N|n(next)用户输入其它用户名以做出下一个判断，而键入其它任意字符可以退出；
next=n
until [[ $next =~ ^[^Nn] ]];do
    read -p "enter user name: " user
    content=`grep $user /etc/passwd`
    if [ $? -eq 0 ];then
	echo $content|cut -d: -f7
    else
	echo "the user($user) not exist"
    fi
    read -p "enter N|n(next) or any other key to quit: " next
done

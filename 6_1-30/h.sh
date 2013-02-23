#!/bin/sh
#
#1、添加10个用户user1到user10，但要求只有用户不存在的情况下才能添加；
for u in user{1..10};do
    grep $u /etc/passwd &> /dev/null
    [ $? -ne 0 ] && useradd $u
    userdel $u
done

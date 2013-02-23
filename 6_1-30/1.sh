#!/bin/sh
#
#一个文本文件内容如下：
#user1  abcd
#user2  g23d
#user3  vgq2
#……    ……
#根据文件内容批量创建用户，第一列为用户名，第二列为对应用户的密码;
file=$1
while read line;do
    username=`echo $line|awk '{print $1}'`
    pwd=`echo $line|awk '{print $2}'`
    useradd $username 
    echo "$username:$pwd" | chpasswd
done < $file

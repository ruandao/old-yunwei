#!/bin/sh
#
#1、将/etc/sysctl.conf文件中以非#(井号)开头的行保存至/tmp/sysctl.conf中
#2、如果/tmp/sysctl.conf文件中net.ipv4.ip_forward的值为0的话，则将其值修改为1
#3、按次序逐个显示等于号之前的指令的名字，并在每一个指令名字添加其编号，形如：
#  1 net.ipv4.ip_forward
#  2 kernel.sysrq
#4、为/tmp/sysctl.conf文件中的每一行添加注释，即在每一非空白行之前添加一个以#开头的行，并保存至文件中。内容形如：
#   # A parameter.
FILE=/tmp/sysctl.conf
egrep -v "^[[:blank:]]*#" /etc/sysctl.conf >> $FILE
sed -i "s/^net.ipv4.ip_forward=0/net.ipv4.ip_forward=1/" $FILE
cat -n $FILE|cut -d= -f1
sed -i "s/^/#/" $FILE && sed -i "s/^#[[:blank:]]$//" $FILE


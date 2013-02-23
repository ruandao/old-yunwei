#!/bin/sh
#
#1、设定变量FILE的值为/etc/passwd
#2、依次向/etc/passwd中的每个用户问好，形如：  (提示：LINES=`wc -l /etc/passwd | cut -d" " -f1`)
# Hello, root.
#3、统计一共有多少个用户
FILE=/etc/passwd
cut -d":" -f1 $FILE | xargs -i echo "Hello,{}"
wc -l $FILE|cut -d" " -f1

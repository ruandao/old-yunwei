#!/bin/sh
#
#1、切换工作目录至/var
#2、依次向/var目录中的每个文件或子目录问好，形如：
#  （提示：for FILE in /var/*; 或for FILE in `ls /var`; ）
#   Hello, log
#   Hello, run
#3、统计/var目录下共有多个文件，并显示出来
cd /var
for FILE in /var/*;do
    echo "Hello,`basename $FILE`"
done
ls /var|wc -l | cut -f1

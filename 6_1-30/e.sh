#!/bin/sh
#
#1、设定变量FILE的值为/etc/passwd
#2、使用循环读取文件/etc/passwd的第2，4，6，10，13，15行，并显示其内容；（提示：LINE=`head -2 /etc/passwd | tail -1`可以取得第2行）
#3、把这些行保存至/tmp/mypasswd文件中
FILE=/tmp/mypasswd
for i in 2 4 6 10 13 15;do
    LINE=`head -$i /etc/passwd | tail -1`
    echo $LINE >> $FILE
done
cat $FILE
rm $FILE
unset FILE

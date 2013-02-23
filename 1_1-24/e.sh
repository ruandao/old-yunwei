#/bin/sh
#1、设定变量FILE的值为/etc/passwd
#2、使用循环读取文件/etc/passwd的第2，4，6，10，13，15行，并显示其内容；（提示：LINE=`head -2 /etc/passwd | tail -1`可以取得第2行）
#3、把这些行保存至/tmp/mypasswd文件中
FILE="/etc/passwd"
cat /dev/null > /tmp/mypasswd
for v in 2 4 6 10 13 15;do
    l=`head -$v $FILE | tail -1`
    echo $l >> /tmp/mypasswd
done
cat /tmp/mypasswd

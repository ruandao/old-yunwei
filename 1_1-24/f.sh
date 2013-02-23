#/bin/sh
#1、设定变量FILE的值为/etc/passwd
#2、依次向/etc/passwd中的每个用户问好，形如： (提示：LINES=`wc -l /etc/passwd | cut -d" " -f1`)
# Hello, root.
#3、统计一共有多少个用户
FILE=/etc/passwd
let count=0
for p in `cat /etc/passwd|cut -f 1 -d :`;do
    echo "Hello, $p"
    count=$(($count+1))
done
echo $count
unset count
unset FILE

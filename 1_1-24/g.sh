#/bin/sh
#1、设定变量FILE的值为/etc/passwd
#2、依次向/etc/passwd中的每个用户问好，并且说出对方的ID是什么，形如：  (提示：LINES=`wc -l /etc/passwd | cut -d" " -f1`)
# Hello, root，your UID is 0.
#3、统计一共有多少个用户
FILE=/etc/passwd
while read line;do
    echo $line | awk -F: '{ print "Hello,",$1,", your UID is ", $3}'
done < $FILE
echo "has `wc -l $FILE|cut -f1 -d" "` users"
unset FILE

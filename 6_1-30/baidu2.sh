#!/bin/sh
#
#2、写脚本实现，可以用shell、perl等。把文件b中有的，但是文件a中没有的所有行，保存为文件c，并统计c的行数。
a=$1
b=$2
while read l;do
    grep "$l" $b &>/dev/null
    [ $? -ne 0 ] && echo "$l" >> $3
done < $a

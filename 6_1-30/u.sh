#!/bin/sh
#
#显示当前系统上所有其VSZ段的值大于4000的进程的进程名字、进程号和VSZ值的大小；
d=`ps aux|sed -n "2,$ p"|awk '{ if ($5>4000) printf "%6d %6d %s\n",$2,$5,$11}'`
if [ $? -eq 0 ];then
    printf "%6s %6s %s\n" 进程号 VSZ值 进程名称
    echo "$d"
fi

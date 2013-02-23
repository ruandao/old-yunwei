#!/bin/sh
#
#1、如果/tmp/net目录存在就切换至此目录，否则就先创建此目录，而后切换进去;
#2、下载ftp://192.168.0.254/pub/Files/rh033.txt至此目录中，并将名字设置为在原名字后面添加上当前日期和时间，形如：
#  rh033-2011-04-25-09-31-10.txt
#3、下载完成后向用户报告完成下载。
DIR=/tmp/net
mkdir -p $DIR
cd $DIR
now=`date +%F`
wget http://blog.csdn.net/deansrk/article/details/6640806 -O rh033-$now.txt &>/dev/null -t1

[ $? -eq 0 ] && echo "download rh033 sccess"| wall || echo "download rh033 fail" | wall

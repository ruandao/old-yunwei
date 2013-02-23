#!/bin/sh
#
#1、下载文件ftp://192.168.0.254/pub/Files/access_log至/tmp目录；
#2、分析并显示/tmp/access_log文件中位于行首的IP中出现次数最多的前5个，并说明每一个出现了多少次；
#3、取出/tmp/access_log文件中以http://开头，后面紧跟着一个域名或IP地址的字符串，比如：http://www.linux.com/install/images/style.css 这个串的http://www.linux.com的部分；而后显示出现次数最多的前5个；
#要求：第2、3功能各以函数的方式实现；
file=/tmp/access_log
log=$1
downlog() {
    cp $log $file
}
mostAccessClient() {
    cat $file|awk '{print $1}'|sort|uniq -c|sort -n |head -5
}

mostAccessR() {
    grep -o "http://[^/]*" $file | sort| uniq -c|sort -n| head -5
}
downlog
mostAccessClient
mostAccessR

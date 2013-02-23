#!/bin/sh
#
#1、显示当前系统日期和时间，而后创建目录/tmp/lstest
#2、切换工作目录至/tmp/lstest
#3、创建目录a1d, b56e, 6test
#4、创建空文件xy, x2y, 732
#5、列出当前目录下以a、x或者6开头的文件或目录；
#6、列出当前目录下以字母开头，后跟一个任意数字，而后跟任意长度字符的文件或目录；
date +%F && date +%T
DIR=/tmp/lstest
mkdir -p $DIR
cd $DIR
mkdir a1d b56e 6test
touch x{y,2y} 732
ls -d {a,x,6}*
ls -d [[:alpha:]][0-9]*
rm -rf $DIR

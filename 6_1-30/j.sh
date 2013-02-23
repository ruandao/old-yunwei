#!/bin/sh
#
#1、将/var/目录下所有文件的文件名的首字母和尾字母显示时改为大写；
for f in /var/*;do
    name=`basename $f`
    mod=`echo $name|sed -e "s/\(.\).*/\U\1/" -e "s/\(.\{1,\}\)\(.\)/\1\U\2/"`
    echo "$name --> $mod"
done

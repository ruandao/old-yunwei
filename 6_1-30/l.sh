#!/bin/sh
#
#1、假设某文件中有如下行：
#    /etc/inittab
#    /etc/pam.d/sudo
#    /usr/share/doc
#    /usr/local/
#    /etc/sysconfig/
#    /var/log/messages
#2、取出如上文件中每一行文件名中不包含路径的文件名，比如，/etc/inittab的文件名为inittab，/etc/sysconfig/的文件名为sysconfig；
#3、把每个文件名的第二个字母显示时改为大写；
for i in `find / -maxdepth 2`;do
    basename $i|sed "s/\(.\)\(.\)\.*/\1\U\2/"
done

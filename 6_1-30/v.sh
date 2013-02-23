#!/bin/sh
#
#查看redhat用户是否登录了系统，如果登录了，就通知当前脚本执行者“redhat is logged on.”；
#否则，就睡眠5秒钟后再次进行测试；直到其登录为止退出；
#要求：使用until循环

w|grep lfs
until [ $? -eq 0 ];do
    sleep 5
    w|grep lfs
done
pts=w|grep `whoami`|egrep -o "pts[^ ]*"|tail -1
write `whoami` $pts <<EOF
lfs is logged on.
EOF

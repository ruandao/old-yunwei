#!/bin/sh
#
#查看redhat用户是否登录了系统，如果登录了，就通知当前脚本执行者“redhat is logged on.”；
#否则，就睡眠5秒钟后再次进行测试；直到其登录为止退出；
#要求：使用until循环
#sleep 5 睡眠5秒
#wall " "  向所有人通告“ ”
id | grep root
[ $? -eq 1 ] && echo "only root user can use this script" && exit 1
who|grep "lfs" &> /dev/null
until [ $? -eq 0 ];do
    sleep 5
    who|grep "lfs" &> /dev/null
done
echo "lfs is logged on." | wall

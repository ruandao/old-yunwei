#!/bin/sh
#
#1、通过ping命令测试192.168.0.151到192.168.0.254之间的所有主机是否在线，
# 如果在线，就显示"ip is up."
# 如果不在线，就显示"ip is down."
for i in 192.168.0.{151..254};do
{
    ping -c 1 -W 1 $i &>/dev/null
    [ $? -eq 0 ] && echo "$i is up." || echo "$i is down."
}&
done
wait

#/bin/sh
#1、通过ping命令测试192.168.0.151到192.168.0.254之间的所有主机是否在线，
# 如果在线，就显示"ip is up."
# 如果不在线，就显示"ip is down."
e="192.168.0."
for i in {151..254};do
    {
	ping -c1 192.168.0.$i 2>&1 >/dev/null
	[ $? -eq 0 ] && echo "$e$i ip is up." || echo "$e$i ip is down." 
    } &
done
wait
unset e

#!/bin/sh
#
#1、扫描192.168.0网段内的主机的在线状态，但需要提示用户输入一段IP地址范围，方式是指定起始IP和结束IP；显示结果形如：
#   The host 192.168.0.1 is UP.
#   The host 192.168.0.2 is DOWN.
#2、使用while循环实现；
#3、主机在线状态的输出结果既要显示在屏幕上，同时要求所有主机信息也保存一份至/tmp/host_state；
#4、为/tmp/host_state文件中所有主机状态为DOWN的行的行首添加一个#（井号）；
#5、分别显示指定范围内所有在线的主机总数和不在线主机总数；
read -p "输入起始ip: " start
read -p "输入结束ip: " end
start=`echo $start|sed "s/.*\.\([[:digit:]]*\)/\1/"`
end=`echo $end|sed "s/.*\.\([[:digit:]]*\)/\1/"`
ip=$start
FILE=/tmp/host_state
rm -f $FILE
STDOUT=`ls -l /proc/$$/fd/1 | awk -F"-> " '{print $2}'`
exec 1>$FILE
while [ $ip -le $end ];do
{
    s="The host 192.168.0.$ip is"
    ping -c1 -W1 192.168.0.$ip &>/dev/null
    if [ $? -eq 0 ];then
	echo "$s UP."
    else
	echo "$s DOWN."
    fi
}&
    ip=$[$ip + 1 ]
done
wait
exec 1>&-
exec 1>$STDOUT
d=`cat $FILE |sort -n -t. -k4 `
echo "$d"|tee $FILE
sed -i "s/\(.*DOWN\)/# \1/" $FILE
egrep "^#" $FILE |wc -l |cut -d" " -f1|xargs echo "online:"
egrep "^[^#]" $FILE |wc -l |cut -d" " -f1|xargs echo "offline:"

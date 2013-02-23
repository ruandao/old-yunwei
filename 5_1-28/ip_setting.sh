#!/bin/sh
#创建临时文件和标识
FLAG=0
TMPFILE=`mktemp /tmp/eth.XXXXXXXXX`
#读取用户输入
read -p "Interface: " ETHCARD
#判定用户输入的网卡是否存在
ALLECARD=`ifconfig -a|awk '/^[^[:space:]l]/{print $1}'`

until echo $ALLECARD | grep "$ETHCARD" &> /dev/null;do
    echo -e "\033[31mWrong Card name.\033[0m"
    read -p "Interface: " ETHCARD
done
#网卡路径的变量，以后要多次应用
ETHFILE=/etc/network/interface
#判定用户输入的协议是否正确
read -p "Boot Protocol: " MYBOOTPROTO
until echo $MYBOOTPROTO | grep -E "dhcp|static" &> /dev/null;do
    echo -e "\033[31mWrong BOOTPROTO.\033[0m"
    read -p "Boot Protocol: " MYBOOTPROTO
done
#判定DHCP和static
if [ "$MYBOOTPROTO" == "dhcp" ];then
    sed -i "s/^BOOTPROTO=.*/BOOTPROTO=dhcp/g" $ETHFILE
    if [ $? -eq 0 ];then
	ifdown $ETHCARD && ifup $ETHCARD
	[ $? -eq 0 ] && echo "Set $ETHCARD done."
    fi
elif [ "$MYBOOTPROTO" == "static" ];then
    cat $ETHFILE > $TMPFILE
    read -p "Ip Address: " MYIP
    #判定IP的正确性
    until [[ $MYIP =~ ^([1-9]|[1-9][0-9]|1[0-9]{1,2}|2[01][0-9]|22[0-3])(\.[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-4])){2}(\.([1-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-4]))$ ]];do
	echo -e "\033[31mWrong IP.\033[0m"
	read -p "Ip Address: " MYIP
    done
    #判定NETMASK的正确性
    read -p "Netmask: " MYNM

    until [[ $MYNM =~ ^255(\.(0|255)){3}$ ]];do
	echo -e "\033[31mWrong NetMask.\033[0m"
	read -p "Netmask: " MYNM
    done

    read -p "Gateway: " MYGW
    #判定IP与GATEWAY的匹配
    for I in {1..4}; do
	IP_NET=`echo $MYIP | cut -d. -f $I`&`echo $MYNM|cut -d. -f $I`
	GW_NET=`echo $MYGW|cut -d. -f $I`&`echo $MYNM | cut -d. -f $I`
	[ $IP_NET -ne $GW_NET ] && FLAG=1 && break
    done

    until [[ $MYGW =~ ^([1-9]|[1-9][0-9]|1[0-9]{1,2}|2[01][0-9]|22[0-3])(\.([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-4])){2}(\.([1-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-4]))$ ]] && [ $FLAG -eq 0 ];do
	echo -e "\033[31mWrong GateWay.\033[0m"
	read -p "Gateway: " MYGW
	for I in {1..4};do
	    [ $[`echo $MYIP | cut -d. -f $I`&`echo $MYNM | cut -d. -f $I`] -ne $[`echo $MYGW|cut -d. -f $I`&`echo $MYNM|cut -d. -f $I`] ] && FLAG=1 && break || FLAG=0
	done
    done
    #文件里面信息是否存在，调用临时文件
    sed -i "s/^BOOTPROTO=.*/BOOTPROTO=static/g" $TMPFILE
    grep "^IPADDR=" $TMPFILE &> /dev/null && sed -i "s/IPADDR=.*/IPADDR=$MYIP/" $TMPFILE || echo "IPADDR=$MYIP" >> $TMPFILE
    grep "^NETMASK=" $TMPFILE &> /dev/null && sed -i "s/NETMASK=.*/NETMASK=$MYNM/" $TMPFILE || echo "NETMASK=$MYNM" >> $TMPFILE

    if [ -z $MYGW ]; then
	sed -i '/^GATEWAY=.*/d' $TMPFILE
    else
	grep "^GATEWAY=" $TMPFILE &> /dev/null && sed -i "s/GATEWAY=.*/GATEWAY=$MYGW/" $TMPFILE || echo "GATEWAY=$MYGW" >> $TMPFILE
    fi
    cp -f $TMPFILE $ETHFILE
    ifdown $ETHCARD && ifup $ETHCARD
    [ $? -eq 0 ] && echo "Set $ETHCARD done."
else
    echo "No such options."
    exit 1
fi
#删除临时文件,避免临时文件过多
rm -f $TMPFILE
	    


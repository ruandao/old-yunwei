#!/bin/sh
#
#1、提示用户选择所要设置的网卡；
#2、提示用户使用dhcp或者static作为选定网卡的BOOTPROTO
#  a、如果用户选择dhcp，则将其配置文件中的BOOTPROTO的值设为dhcp，而后重启此网卡；
#  b、如果用户选择static，则将其配置文件中的BOOTPROTO的值设为static，并提示用户输入IP地址，子网掩码和网关；其中网关可以为空，但IP地址或子网掩码不能为空；设置完成后重启此网卡；
#3、无论上述动态或静态设定，设定完成后将网卡IP地址设定后信息再次显示给用户；
#考虑：1、如果用户没有做出任何修改之前就不想设置了，如何退出？
#      2、如果用户已经设定了一些信息，如IP地址等却又不想设置了，而使用了Ctrl+c，如何处置？   
tmpfile=`mktemp /tmp/w.XXXX`
cp /etc/network/interfaces $tmpfile
myclear() {
    rm $tmpfile
}
trap "myclear && exit 1" 2
read -p "选择网卡: " card

bootproto=xxx
until [[ $bootproto =~ (dhcp|static) ]];do
    read -p "选择配置方式(dhcp|static): " bootproto
done

if [ $bootproto = dhcp ];then
    sed -i "s/\(iface $card \b.*\b \)\(.*\)$/\1dhcp/" $tmpfile
else
    sed -i "s/\(iface $card \b.*\b \)\(.*\)$/\1static/" $tmpfile
    ip=
    netmask=
    re=^\([0-9]\{1,3\}\.\)\{3\}[0-9]\{1,3\}$
    until [[ $ip =~ $re ]];do
	read -p "输入ip:" ip
    done
    until [[ $netmask =~ $re ]];do
	read -p "输入子网掩码:" netmask
    done
    read -p "输入网关:" gw
    cat $tmpfile
    echo
    ptn="/iface[[:blank:]]*$card.*static/,+3s/(address|netmask|gateway).*//;         
/iface[[:blank:]]*$card.*static/a   address $ip\nnetmask $netmask\n"
    if [ -n $gw ];then
	ptn=$ptn"gateway $gw"
    fi
    echo "$ptn"
    sed -i "$ptn" $tmpfile
fi
cat $tmpfile
myclear

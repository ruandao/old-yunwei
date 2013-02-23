#!/bin/sh
#
#1、提示用户可以输入”mem"查看本机物理内存使用信息，"swap"显示虚拟内存使用信息；
#2、当用户输入mem时，获取当前主机物理内存的大小，已经使用的空间及空闲空间大小；如果已用空间超出总空间的90%，则以红色字体警告；否则，则以绿色字体显示空间剩余百分比；
#3、当用户输入"swap"时，获取当前主机虚拟内存的大小，已经使用的空间及空闲空间的大小；如果已用空间超出总空间的90%，则以红色字体警告；否则，则以绿色字体显示空间剩余百分比；
#4、其它信息则说明是错误输入；
v=
until [[ $v =~ (mem|swap) ]];do
    if [ ! -z $v ];then
	echo "错误输入"
    fi
    read -p "mem查看本机物理内存大小\nwap查看虚拟内存使用信息: " v
done
red="\033[31m"
green="\033[32m"
default="\033[0m"
function getMemSwap() {
    echo $1
    t=$1
    total=`free |grep $t|awk '{print $2}'`
    used=`free | grep $t|awk '{print $3}'`
    unused=$[$total - $used]
    scope=$[$used * 100 / $total]
    if [ $scope -gt 90 ];then
	printf "${red}total:%7dused:%7dunused:%7d %2d%%警告！！！\n$default" $total $used $unused $scope
    else
	printf "${green}total:%7dused:%7dunused:%7d %2d%%\n$default" $total $used $unused $scope
    fi
}
mem() {
    getMemSwap "Mem"
}
swap() {
    getMemSwap "Swap"
}
if [ $v = "mem" ];then
    mem
else
    swap
fi

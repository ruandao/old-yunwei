#!/bin/sh
#
#1、创建一个函数，能接受两个参数：
#1)第一个参数为URL，即可下载的文件；第二个参数为目录，即下载后保存的位置；
#2)如果用户给的目录不存在，则提示用户是否创建；如果创建就继续执行，否则，函数返回一个51的错误值给调用脚本；
#3)如果给的目录存在，则下载文件；下载命令执行结束后测试文件下载成功与否；如果成功，则返回0给调用脚本，否则，返回52给调用脚本；
#2、主函数：
#1)提示用户输入要下载文件的URL和保存的目录；
#2)调用函数执行下载；如果函数返回0，则告诉用户下载成功；如果函数返回51，则告诉用户用户给定的目录不存在导致下载失败；如果函数返回52，则告诉用户下载过程失败；

download() {
    url=$1
    dir=$2
    if [ ! -d $dir ];then
	read -p "$dir not exist,create it (y|n): " opt
	if [ $opt = y ];then
	    mkdir -p $dir
	else
	    return 51
	fi
    fi
    cd $dir
    wget -t 1 $url &>/dev/null
    [ $? -eq 0 ] && return 0 || return 52
}
main() {
    read -p "enter url: " url
    read -p "enter dir: " dir
    download $url $dir
    case $? in
	0) echo "download success";;
	51) echo "$dir not exist so fail";;
	52) echo "download fail";;
	*) echo "script error" && exit 1;;
    esac
}
main

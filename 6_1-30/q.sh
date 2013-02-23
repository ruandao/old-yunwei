#!/bin/sh
#
#1、判断一个指定的脚本是否是语法错误；如果有错误，则提醒用户键入Q或者q无视错误并退出，其它任何键可以通过vim打开这个指定的脚本；
#2、如果用户通过vim打开编辑后保存退出时仍然有错误，则重复第1步中的内容；否则，就正常关闭退出。
sh -n $1 &>/dev/null
if [ $? -ne 0 ];then
    read -p "enter q|Q to quit or any other key to edit it:" enter      
    until [[ $enter =~ [qQ] ]];do
	# any other key will make people edit this file
	vim $1

	sh -n $1 &>/dev/null
	if [ $? -eq 0 ];then
	    break
	fi
	read -p "enter q|Q to quit or any other key to edit it:" enter      
    done
fi

#!/bin/sh
#
#1. 可以自动在U盘上创建一个1GB的逻辑分区，并格式化为ext3分区格式
#2. 自动挂载第一步创建的分区，并且开机挂载
#3. 让用户手动选择创建3个用户，自动创建并分别密码为他们的用户名，并让建立一个指定的(该逻辑分区下的目录，如"研发")研发组，让这三个用户自动加入。
#4. 让用户指定一个目录，自动更改那个目录的属组为刚才第3步建立的组，并且加入SUID权限和STICKY粘帖位
#5. 可以设定指定文件的ACL权限。
#6. 整个过程中抓取用户的ctrl  + c 撤销操作，不保存退出。
id | grep "uid=0(root)" &>/dev/null
[ $? -ne 0 ] && echo "要有超级管理员的权限！！" && exit 1
ctrl_c() {
    echo "用户取消了操作，执行清理"
    exit 1
}
trap "ctrl_c" 2
#收集信息
collection() {
    echo "建立逻辑分区"
    read -p "输入设备名称：" dev
    read -p "输入新建分区要挂载的位置：" mount_dir

    # 用户名密码放在：user$i pwd$i上
    for i in 1 2 3;do
	read -p "输入用户$i的用户名："  user$i
	read -p "输入用户$i的密码  ："  pwd$i
    done
    read -p "输入研发组名：" group
    read -p "输入组的目录(注意该目录应该是$mount_dir下的子目录）：" DIR
}
collection_fake() {
    dev=/dev/sdd
    mount_dir=/home/yan/go
    user1=test1
    user2=test2
    user3=test3
    pwd1=pwd1
    pwd2=pwd2
    pwd3=pwd3
    group=ggggg
    DIR=sb
}
createDisk() {
    fdisk -l $dev|grep Extended &>/dev/null
    if [ $? -ne 0 ];then
	# 说明没有扩展分区，需要新建立扩展分区下
	fdisk $dev &>/dev/null <<EOF
n
e



w
EOF
	[ $? -ne 0 ] && echo "可能磁盘空间不够哦" && exit 1
	echo "完成建立扩展分区"
    fi
    fdisk $dev &>/dev/null <<EOF
n
l

+1G
w
EOF
    echo "完成建立新逻辑分区"
    partprobe $dev
#    [ $? -eq 0 ] && echo "让内核重新读入分区数据成功" || echo "让内核重载分区数据失败" && exit 1
    partition=`fdisk -l $dev | tail -1 |cut -f1 -d" "` 
    echo -e "新逻辑分区是：$partition\n开始格式化新分区"
    mkfs.ext3 $partition -q
    [ $? -eq 0 ] && echo "完成格式化新分区" || 
    { echo "格式化新分区$partition 失败";exit 1;}
    if [ -d $mount_dir ];then
	echo "$mount_dir 已经存在，无需建立"
    else
	echo "$mount_dir 需要建立"
	mkdir $mount_dir
	[ -d $mount_dir ] && echo "建立成功" || { echo "建立失败";exit 1;}
    fi
    mount $partition $mount_dir -o acl
    [ $? -eq 0 ] && echo "挂载分区$partition到目录$mount_dir成功" ||
    { echo "挂载失败";exit 1;}
    echo "$partition $mount_dir ext3 defaults 0 0 " >> /etc/fstab
    [ $? -eq 0 ] && echo "建立自动挂载成功" || 
    { echo "建立自动挂载失败";exit 1;}
}
doit() {
    groupadd $group
    echo "建立研发组：$group"
    for i in 1 2 3;do
	useradd -g $group $user$i
	echo "$user$i:$pwd$i" | chpasswd $user$i
	echo "建立用户 $user$i 并已经加入研发组$group"
    done
    DIR=$mount_dir$DIR
    mkdir $DIR &>/dev/null
    echo "建立研发目录$DIR成功"
    chgrp $group $DIR
    chmod 5770 $DIR
}

# ok do it now
collection_fake
createDisk
doit

clear() {
    echo "卸载挂载目录$mount_dir"
    umount $mount_dir
    echo "删除设备上的分区信息"
    fdisk $dev <<EOF
d
1
w
EOF
    partprobe $dev
    for i in 1 2 3; do
	echo "删除新建立的用户: $user$i"
	userdel $user$i
    done
    echo "删除新建了的组: $group"
    groupdel $group
}
clear

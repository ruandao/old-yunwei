#!/bin/sh
#
#写一个脚本，实现创建并管理LV：
#说明：脚本执行时，可以显示一个菜单给用户，形如下面：
#A Create an LV.
#B Create an LV in an existing VG.
#C Extend an LV.
#D Reduce an LV.
#
#
#如果用户选择了A项，则完成如下功能：
#1)显示当前系统上的所有磁盘及磁盘柱面的相关信息：共有柱面数及空闲柱面范围；而后提示用户选择一个特定的磁盘，
#  做为创建LV的磁盘；
#2)当用户选定磁盘后将选定磁盘的分区信息显示给用户；
#3)询问用户创建的VG名字、PV个数及每个PV的大小；而后新建分分区，分区大小对应于各PV大小；
#4)而后创建相应的PV，并以之创建出VG；
#5)创建LV:
#a)提示用户输入LV的大小及名称后创建LV；
#b)格式化此LV；
#6)提示用户指定挂载点
#  a)如果挂载点已经存在，且挂载有其它存储设备，则提示用户换一个，直到换到一个可用挂载点；
#  b)否则，则使用此挂载点挂载此LV; 
#
#
#如果用户选择了B项，则完成以下功能：
#1)提示用户输入要创建的LV的名字，大小，和VG的名字；
#2)创建此LV；（说明：在创建LV之前要测试VG中所余的空间是否够指定的LV使用；）
#
#
#如果用户选择了C项，则完成以下功能：
#1)提示用户选定LV；而后显示当前LV的大小，并提示用户指定扩展后的大小；
#2)扩展此LV至用户指定的大小；（提示：扩展之前要测试当前VG中是否仍有足够的磁盘空间可用；）
#
#
#如果用户选择了D项，则完成以下功能：
#1)提示用户选定LV；而后显示当前LV的大小，并提示用户指定缩减后的大小；
#2)缩减此LV至用户指定的大小；（提示：缩减之前要测试当前缩减后的空间是否能容纳当前LV中的所有数据；）
id|grep "uid=0(root)" &>/dev/null
[ $? -ne 0 ] && echo "you should get root permitted!" && exit 1
showVGS() {
    VGS=`vgdisplay | grep "VG Name"|awk '{print $3}'`
    echo "current has these vg:"
    echo -e "\t"$VGS
}
createExtendPartition() {
    # $1 was zhe device name
    echo "prepare for create Extend!"
    fdisk -l $1 | grep "Extended" &>/dev/null
    if [ $? -eq 0 ];then
	echo "Extend found,use exist extend!"
	return
    fi
    echo "create Extend:"
    fdisk $1 <<EOF
n
e



w
EOF
    if [ $? -ne 0 ];then
	echo " create extended partition fail!"
	exit 1
    fi
}
createPVdisk() {
    # $1 device
    # $2 PVsize
    echo "create pv"
    INFO=`fdisk $1 2>/dev/null <<EOF
n
l

+$2
w
EOF`
    partprobe $1
    # 获取刚才建立的pv号
    partitionN=`echo "$INFO"|sed -n "s/.*Adding logical partition \([0-9]*\)$/\1/p"`
    echo "create pv finished"
    echo "partitionN is $partitionN"
    return $partitionN
}
setDiskType() {
    # $1 device
    # $2 partition number
    echo "set pv type to 8e"
    fdisk $1 &>/dev/null <<EOF
t
$2
8e
w
EOF
    echo "set pv type to 8e finished"
}
A() {
    
    Disk=`fdisk -l 2>/dev/null|grep -v Extended | grep Di|awk '{print $2}'|grep -v '^[^/]'|cut -d: -f1`
    OK=1
    until [ $OK -eq 0 ];do
	printf "%-15s %-20s device\n" "total sectors" "empty sectors"
	for i in $Disk;do
	    total=`fdisk -l $i 2>/dev/null|grep "total"|awk -F"total" '{print $2}'|awk '{print $1}'`

	    star=`fdisk -l $i 2>/dev/null|egrep "^/.*[[:digit:]]+.*"|grep -v "Extended"|tail -1|awk '{print $3}'`
	    if [ -z "$star" ];then
		star=0
	    fi
	    end=`fdisk -l $i 2>/dev/null|grep total|awk -F"total" '{print $2}'|awk '{print $1}'`
	    if [ $[$end-$star] -eq 1 ];then
		star="no"
		end="free"
	    fi
	    printf "%10s %10s-%-10s %s\n" "$total" "$star" "$end" $i
	done
	read -p "Your should choose a DISK to use(include path): " dev
	echo "$Disk"|egrep "^$dev$" &>/dev/null
	if [ $? -eq 0 ];then
	    OK=0
	fi
    done
    fdisk -l $dev 2>/dev/null|sed -n "/Device Boot/,$ p"
    showVGS
    read -p "VG name:" VG
    read -p "how much pv,you want to create:" PV_COUNT
    read -p "pv size(xxK/xxM/xxG):" PVSIZE
    # 建立扩展区，防止pv数超过4的情况下primary不够用
    createExtendPartition $dev
    declare -a partitionArr
    for(( i=0;i<$PV_COUNT;i++));do
	echo "create the ${i}s pv"
	#建立pv
	createPVdisk $dev $PVSIZE
	newDiskN="$?"
	setDiskType $dev $newDiskN
	partitionArr[$i]="$dev$newDiskN"
	echo "pvcreate ${partitionArr[$i]}"
	pvcreate ${partitionArr[$i]}
	echo "pvcreate ${partitionArr[$i]} finished"
    done
    # 建立vg
    echo "sync disk"
    partprobe $dev
    echo "sync disk finished"
    LVS=`fdisk -l $dev|sed -n 's@\([^ ]*\).*Linux LVM@\1@p'`
    
    echo "create vg"
    vgcreate $VG ${partitionArr[$[${#partitionArr[@]}-1]]}
    echo "add pv to vgs"
    for(( i=0;i<$[${#partitionArr[@]} - 1];i++));do
	vgextend $VG ${partitionArr[$i]}
    done
    read -p "enter lv name:" LVNAME
    read -p "enter lv size(xxK/xxM/xxG):" LVSIZE
    lvcreate -L $LVSIZE -n$LVNAME $VG
    mkfs.ext3 /dev/$VG/$LVNAME
    OK=1
    until [ $OK -eq 0 ];do
	read -p "enter mount absolute path:" MOUNT_POINT
	mount|awk '{print $3}'|grep "$MOUNT_POINT$" &>/dev/null
	if [ $? -eq 0 ];then
	    echo "the mount point had been used!!"
	    echo "choose another"
	else
	    OK=0
	fi
    done
	
    mount /dev/$VG/$LVNAME $MOUNT_POINT
    
}

B() {
    OK=1
    until [ $OK -eq 0 ];do
	showVGS
	read -p "vg name(choose one vg):" VG
	read -p "lv name:" LVNAME
	read -p "lv size:" LVSIZE
	lvcreate -L $LVSIZE -n $LVNAME $VG
	if [ $? -eq 5 ];then
	    echo "lv size large then vg free space,Retry"
	else
	    OK=0
	fi
    done
}
chooseLV() {
    OK=1
    LVS=`lvdisplay | grep "LV Path"|awk '{print $3}'`
    until [ $OK -eq 0 ];do
	echo "choose an lv($LVS 要输入全称！):"
	read LV
#	echo $LVS|grep " $LV " &>/dev/null
	echo $LVS $LV
	echo $LVS|grep "$LV"
	if [ $? -eq 0 ];then
	    OK=0
	fi
    done
    # display the lv info
    lvdisplay $LV
}
C() {
    chooseLV
    VG=`lvdisplay $LV|grep "VG Name"|awk '{print $3}'`
    OK=1
    until [ $OK -eq 0 ];do
	read -p "输入要增加到(xxG):" EXTSIZE
	lvextend -L $EXTSIZE $LV
	result=$?
	if [ $result -eq 5 ];then
	    echo "磁盘空间不够"
	elif [ $result -eq 0 ];then
	    resize2fs $LV
	    OK=0
	else
	    echo "发生错误"
	    exit 1
	fi
    done
}
D() {
    chooseLV
    umount $LV
    OK=1
    until [ $OK -eq 0 ];do
	read -p "输入要将设备减少到(xxM/xxG 整数，不支持小数):" RSIZE
	e2fsck -f $LV
	resize2fs $LV $RSIZE
	if [ $? -eq 0 ];then
	    OK=0
	    lvreduce -L $RSIZE $LV<<EOF
y
EOF
	else
	    echo "错误！！"
	fi
    done
}

choose() {
    selecter=
    until [[ $selecter =~ ^[a-dA-D]$ ]];do
	echo "A Create an LV."
	echo "B Create an LV in an existing VG."
	echo "C Extend an LV."
	echo "D Reduce an LV."
	read -p "Enter select: " selecter
    done
    case $selecter in
	"a"|"A")
	    A;;
	"b"|"B")
	    B;;
	"c"|"C")
	    C;;
	"d"|"D")
	    D;;
    esac
}

choose

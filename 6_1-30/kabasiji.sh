#!/bin/sh
#
#某文件内容如下：
# jack  huaxue   90
# tom  huaxue    70
# jack  shuxue    99
# tom  shuxue    80
#要求算出jack和tom的2科的平均分，用shell实现
file=$1
jack=0
getAvg() {
    sum=0
    for i in `grep "$1" $file|awk '{print $3}'`;do
	sum=$[$sum + $i]
    done
    echo $[$sum/2]
}
echo "jack get:"`getAvg jack`
echo "tom get:"`getAvg tom`

    

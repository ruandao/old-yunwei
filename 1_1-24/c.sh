#/bin/sh
#1、传递两个整数给脚本，让脚本分别计算并显示这两个整数的和、差、积、商。
declare -i a=$1
declare -i b=$2
echo "sum: $(($a+$b))"
echo "differ: $(($a-$b))"
echo "product: $(($a*$b))"
echo "quotient: $(($a/$b))"

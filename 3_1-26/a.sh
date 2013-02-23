#/bin/sh
#
# 文件描述符测试
{
    echo "jjjj" >&3
}&
exec 3> jjje
echo "wwww" >&3
{
    echo "elfl" >&3
    exec 4>ooo
    echo "ldfk" >&4
    sleep 1
    echo "wwqq" >&4
} &
exec 4> ooo2
echo "qqqq" >&4

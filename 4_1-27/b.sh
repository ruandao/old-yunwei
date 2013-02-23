#/bin/sh
#
#1、向系统中添加20个用户，名字为linuxer1-linuxer20，密码分别为其用户名，要使用while循环；
#2、要求：在添加每个用户之前事先判断用户是否存在，如果已经存在，则不再添加此用户；
#3、添加完成后，显示linuxer1-linuxer20每个用户名及对应的UID号码和GID号码，形如
let n=1
while [ $n -le 20 ] ;do
    grep linuxer$n /etc/passwd
    if [ $? -eq 0 ];then
	# the user had been exist
    else
	# add user
    fi
    n=$[ $n+1]
done

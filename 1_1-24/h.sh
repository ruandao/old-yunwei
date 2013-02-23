#/bin/sh
#1、添加10个用户user1到user10，但要求只有用户不存在的情况下才能添加；
echo "enter passwd:"
read p
for i in user{1..10};do
    egrep "^$i:" /etc/passwd
    if [ $? -eq 1 ];then
	echo $p | sudo -S useradd $i
	if [ $? -eq 0 ];then
	    echo "add success"
	fi
    else
	echo "had this user"
    fi
done
for i in user{1..10};do
    echo $p | sudo -S userdel -r $i
done
cat /etc/passwd

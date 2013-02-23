#/bin/sh
#
#1、将/etc/inittab文件中以id开头后面跟了两个冒号且两个冒号间有一个数字的那一行中的那两个冒号间的数字改为3；
#2、将/etc/passwd文件中以n开头的所有单词的词首字母改为大写；
#3、在/proc/meminfo文件中所有以HugePages开头的行后面添加“# For performancing”一个新行；
#4、删除/etc/inittab文件中所有以#开头，或者以一些空白字符后跟一个#开头的行，并且将所有以一个空格后跟一个数字结尾的行中的那个行尾的数字改为0；
sed "s@^id:\d:@id:3:@p" /etc/inittab  # after fix edit
#deansrk: sed s@^id:[0-9]:@id:3:@g /etc/inittab
sed "s@\bn@N@g" /etc/passwd
#deansrk: sed '1,$s/\bn/N/pg' /etc/passwd
sed "/^HugePages/a/# For performancing" /proc/meminfo
#deansrk: sed "/HugePages/a\# For performancing" /proc/meminfo
sed "/^[[:blank:]]+#/d" -e "s/ \d$/ 0/" /etc/inittab
#deansrk: sed -e '/^[[:space:]]*#.*/d' /etc/inittab -e "s/[[:space:]][0-9]$/ 0/g" /etc/inittab

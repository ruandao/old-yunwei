#!/bin/sh
#
#1、写脚本实现，可以用shell、perl等。在目录/tmp下找到100个以abc开头的文件，然后把这些文件的第一行保存到文件new中。 
c=0
for f in `ls /tmp/abc*`;do
    c=$[$c + 1 ]
    if [ $c -gt 100 ];then
	break
    fi
    head -1 $f >> new
done

#!/bin/sh
#
#判断用户输入的是否为Q或者q，如果是，就显示”Quting...";否则，就显示，“Are you crazy？”；
read input;
if [[ $input =~ [Qq] ]];then
    echo "Quting..."
else
    echo "Are you crazy?"
fi

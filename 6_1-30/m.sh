#!/bin/sh
#
#判断一个文件是否存在，如果存在就显示其存在；
[ -e ~/.emacs ] && echo ".emacs exist" || echo ".emacs not exist"

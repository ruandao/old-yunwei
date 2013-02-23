#!/bin/sh
#
#4、计算100以内所有偶数的和；
let c=0
let i=0
until [ $i -gt 100 ];do
    c=$[$c+$i]
    i=$[$i+2]
done
echo $c

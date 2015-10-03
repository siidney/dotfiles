#!/bin/sh


count=`ps aux | grep -c $1`

if [ "$(pidof $1)" ]
then
    i3-msg "[class=$2] focus"
else
    $1
fi

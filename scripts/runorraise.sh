#!/bin/sh
# Basic i3 run or raise(focus)

if [ "$(pidof $1)" ]
then
    i3-msg "[class=$2] focus"
else
    $1
fi

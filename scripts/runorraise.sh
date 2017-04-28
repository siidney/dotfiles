#!/bin/sh
# Basic i3 run or raise(focus)

# @param $1 program name
# @param $2 program class name

if [ "$(pidof "$1")" ]
then
    xdo activate -N $2
else
    $1
fi

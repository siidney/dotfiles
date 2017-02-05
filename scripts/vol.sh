#!/bin/sh
# get and print master volume

test=$(amixer get Master | awk '$0~/%/{print $4}' | tr -d '[]')

echo $test

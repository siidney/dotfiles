#!/bin/sh
# feh! slideshow wrapper script

# prompt for directory
directory_prompt(){
    printf "\E[0,36mPlease intput the dir path: "
    read dir
}

# check for directory and flags
if [ $# -eq 0 ]
then
    directory_prompt
else
    for var in "$@"
    do
        dir+=$var
        dir+=" "
    done
fi

feh -s --recursive --slideshow-delay 5.0 --fullscreen --auto-zoom $dir

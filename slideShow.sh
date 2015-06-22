# feh! slideshow wrapper script
#!/bin/sh


if [ $# -eq 0 ]
then
    echo -e "\E[0,36mPlease input the dir path: "
    read dir
fi

feh -s --recursive --slideshow-delay 5.0 --fullscreen --auto-zoom $1

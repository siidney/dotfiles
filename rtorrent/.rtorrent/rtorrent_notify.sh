#!/bin/sh
# rtorrent torrent complete notification

# exit on no args
if [ $# -gt 0 ]
then
    action=$1
    torrent=$2
else
    exit 1
fi

notify-send "RTorrent" "Download $action \n$torrent"

#notify-send "Download $action" "$torrent"

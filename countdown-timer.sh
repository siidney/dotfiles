# simple bash countdown timer
#/bin/sh

# play the alarm
sound_alarm(){
    COUNTER=0
        # alert status of countdown
        notify-send -i starred COUNTDOWN_COMPLETE "$timer $strTotal"
    while [ $COUNTER -lt 3 ]; do
        # sound the alarm
        mpg123 -q /home/siid/Sounds/Woop-Woop-SoundBible.com-198943467.mp3
        let COUNTER++
    done
}
# check status of mpd
mpc_status(){
    for i in $( mpc --format "" ); do
        a=$i
        break
    done

    if [ $a = "[playing]" ]
    then
        mpc toggle > /dev/null
        sound_alarm
        mpc toggle > /dev/null
    else
        sound_alarm
    fi
}
# clear screen and move cursor
redraw(){
    local str width height length

    width=$(tput cols)
    height=$(tput lines)

    # clear the screen
    clear
    tput cup $(((height -1) / 2)) $(((width / 2) - (${#timer} / 2)))
    echo -ne "\E[0.36m" $timer \\r
    tput cup $((height/ 2)) $(((width / 2) - (${#1} / 2)))
    echo -ne "\E[0,36m" $1 \\r
}
# validate input (check seconds and minutes not greater than 59)
validate(){
    # convert to base ten ( prevent leading octal error )
    hours=$((10#$hours))
    minutes=$((10#$minutes))
    seconds=$((10#$seconds))

    # seconds
    if [ $seconds -gt 59 ]
    then
        while [ $seconds -ge 60 ]; do
            let minutes++
            seconds=$((seconds-60))
        done
    fi

    # minutes
    if [ $minutes -gt 59 ]
    then
        while [ $minutes -ge 60 ]; do
            let hours++
            minutes=$((minutes-60))
        done
    fi
}
# string formatting spacers
get_spacer_minutes(){
    if [ $minutes -lt 10 ] && [ ${#minutes} -lt 2 ]
    then
        spacer1=":0"
    else
        spacer1=":"
    fi
}
get_spacer_seconds(){
    if [ $seconds -lt 10 ] && [ ${#seconds} -lt 2 ]
    then
        spacer2=":0"
    else
        spacer2=":"
    fi
}
echo -e "\E[0,36mPlease input the countdown time in (hh mm ss): "
tput sgr0
read hours minutes seconds

# save the screen
tput smcup

validate hours minutes seconds

# get total time in seconds
# total number of minutes * 60 + seconds
total=$(($((minutes + (hours * 60))) * 60 + seconds))

get_spacer_minutes
get_spacer_seconds

strTotal="$hours$spacer1$minutes$spacer2$seconds"

timer="COUNTDOWN"

if [ $# -gt 0 ]
then
    timer=$1
fi

while [ $total -gt 0 ]; do

    get_spacer_minutes
    get_spacer_seconds

    redraw $hours$spacer1$minutes$spacer2$seconds
    #redraw $total

    if [ $minutes -eq 0 ] && [ $hours -gt 0 ] && [ $seconds -eq 0 ]
    then
        let hours--
        minutes=60
    fi

    if [ $seconds -eq 0 ] && [ $minutes -gt 0 ]
    then
        let minutes--
        seconds=60
    fi

    if [ $hours -eq 0 ] && [ $minutes -eq 0 ] && [ $seconds -le 3 ]
    then
        echo -ne "\a" \\r
    fi

    let seconds--
    let total--

    sleep 1
done

# reset changes
tput sgr0
# restore screen
tput rmcup

echo "$timer FINISHED: $strTotal"

mpc_status

# simple bash countdown timer
#/bin/zsh

# play the alarm
sound_alarm(){
    COUNTER=0
        # alert status of countdown
        notify-send -i starred COUNTDOWN_COMPLETE "$strtotal"
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

    str=$1
    width=$(tput cols)
    height=$(tput lines)
    length=${#str}

    # clear the screen
    clear
    tput cup $((height / 2)) $(((width / 2) - (length / 2)))
    echo -ne "\E[0,36m"$str \\r
}

echo -e "\E[0,36mPlease input the countdown time in minutes and seconds: "
tput sgr0
read minutes seconds

# save the screen
tput smcup

total=$((minutes * 60 + seconds))

strtotal="$minutes\m $seconds\s"

while [ $total -gt 0 ]; do
    if [ $seconds -lt 10 ] && [ $seconds -ne 00 ]
    then
        spacer=":0"
    else
        spacer=":"
    fi

    redraw $minutes$spacer$seconds

    if [ $seconds -eq 0 ]
    then
        let minutes--
        seconds=60
    fi

    if [ $minutes -eq 0 ] && [ $seconds -le 3 ]
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

echo "COUNTDOWN FINISHED: $strtotal"

mpc_status

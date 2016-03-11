# create tmux sessions
# system - htop, iotop, rtorrent, newsbeuter
#!/bin/sh

session_system="System"

# ensure session not already exists
tmux has-session -t $session_system

if [ $? != 0 ]; then
    # create new system session with 3 windows
    tmux new-session -s $session_system -d -n 'Htop'
    tmux new-window -t $session_system -n 'IOtop'
    tmux new-window -t $session_system -n 'Rss/Torrent'
    tmux split-window -h -t $session_system

    # start applications on each window
    tmux send-keys -t $session_system:0 'htop' C-m
    tmux send-keys -t $session_system:1 'iotop -o' C-m
    tmux send-keys -t $session_system:2.0 'rtorrent' C-m
    tmux send-keys -t $session_system:2.1 'newsbeuter' C-m

    # select first window
    tmux select-window -t $session_system:0
fi

# attach session to shell
#$tmux attach -t $session_system
urxvt -name sys_info -e tmux attach -t $session_system

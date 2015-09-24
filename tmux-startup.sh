# create startup tmux session displaying htop, rtorrent and newsbeuter
#/bin/sh

session_name="System"

# ensure session not already exists
tmux has-session -t $session_name

if [ $? != 0 ]; then
    # create new named session with 3 windows
    tmux new-session -s $session_name -d -n 'Htop'
    tmux new-window -t $session_name -n 'Rss/Torrent'
    tmux split-window -h -t $session_name

    # start applications on each window
    tmux send-keys -t $session_name:0 'htop' C-m
    tmux send-keys -t $session_name:1.0 'rtorrent' C-m
    tmux send-keys -t $session_name:1.1 'newsbeuter' C-m

    # select first window
    tmux select-window -t $session_name:0
fi

# attach session to shell
tmux attach -t $session_name

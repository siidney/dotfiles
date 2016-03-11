# create tmux session
# communication - email, irc
#!/bin/sh

session_communication="Communication"

# ensure session not already exists
tmux has-session -t $session_communication

if [ $? != 0 ]; then
    # create new communication session with 2 windows
    tmux new-session -s $session_communication -d -n 'Mutt'
    tmux new-window -t $session_communication -n 'IRC'

    # start applications on each window
    tmux send-keys -t $session_communication:0 'mutt' C-m
    tmux send-keys -t $session_communication:1 'irssi' C-m

    # select first window
    tmux select-window -t $session_communication:0
fi

# attach session to shell
#$tmux attach -t $session_communication
urxvt -name comm -e tmux attach -t $session_communication

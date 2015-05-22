#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

# enable numlock on startup
numlockx &
mpd &
feh --bg-scale ~/.i3/backgrounds/i3-background.png &

# exec gnome-session
# exec startkde
# exec startxfce4
# ...or the Window Manager of your choice
# exec enlightenment_start
# exec xterm
# exec $1
# exec tdm
# exec dbus-launch awesome
# exec dwm
 exec i3
# exec enlightenment_start

#|/bin/sh

# checks whether systemd timer is active
if [ $(systemctl is-active mbsync@${USER}.timer) != 'active' ] ; then
    systemctl start mbsync@${USER}.timer
fi

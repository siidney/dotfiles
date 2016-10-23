#!/bin/sh
# Open MailTo links in mutt

TERMINAL="urxvt"
TERMPARAMS="-geometry 120x40 -name urxvt_dropdown"   # i3 floating window
CMD="mutt"

exec "$TERMINAL" "$TERMPARAMS" -e $CMD "$@"

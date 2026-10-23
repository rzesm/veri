#!/bin/bash

# Cancel active selection if there is one
if pgrep -f "slurp" > /dev/null; then
    pkill -x wayfreeze
    pkill -x slurp
    pkill -x grim
    exit 0
fi

exec wayfreeze & PID=$!
sleep .1

SELECTION=$(slurp -b 00000033 -c ffffff99 -w 1)

if [ -n "$SELECTION" ]; then
    grim -g "$SELECTION" - | wl-copy
    notify-send "Image copied"
fi

kill $PID

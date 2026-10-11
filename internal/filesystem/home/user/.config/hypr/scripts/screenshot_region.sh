#!/bin/bash

exec wayfreeze & PID=$!
sleep .1

SELECTION=$(slurp -b 00000033 -c ffffff99 -w 1)

if [ -n "$SELECTION" ]; then
    grim -g "$SELECTION" - | wl-copy
    notify-send "Image copied"
fi

kill $PID

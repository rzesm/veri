#!/bin/bash

exec wayfreeze & PID=$!
sleep .1

SELECTION=$(slurp -b 000000b3 -c ffffff20)

if [ -n "$SELECTION" ]; then
    grim -g "$SELECTION" - | wl-copy
    notify-send "Image copied"
fi

kill $PID

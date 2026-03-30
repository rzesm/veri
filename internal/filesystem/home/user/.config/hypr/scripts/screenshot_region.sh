#!/bin/bash

exec wayfreeze & PID=$!
sleep .1

GEOM=$(slurp -b 000000b3 -c 000000b3)

if [ -n "$GEOM" ]; then
    grim -g "$GEOM" - | wl-copy
    notify-send "Image copied"
fi

kill $PID

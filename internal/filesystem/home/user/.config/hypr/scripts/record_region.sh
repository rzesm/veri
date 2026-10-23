#!/bin/bash

# Cancel active selection if there is one
if pgrep -f "slurp" > /dev/null; then
    pkill -x wayfreeze
    pkill -x slurp
    pkill -x grim
    exit 0
fi

# Cancel an existing recording
if pkill wf-recorder; then 
    notify-send "Recording saved"
    sleep 0.5
    pkill -RTMIN+1 waybar
    exit 0
fi

# Get geometry or exit
if ! geometry=$(slurp -b 00000033 -c ff555599 -w 1); then
    notify-send "Recording cancelled"
    exit 0
fi

# Start recording
wf-recorder --audio=$(pactl get-default-sink).monitor -g "$geometry" -f "$(xdg-user-dir VIDEOS)/$(date +'%Y-%m-%d_%H-%M-%S').mp4" &

# Refresh waybar indicator
sleep 0.5
pkill -RTMIN+1 waybar

#!/bin/bash

# if already recording
if pkill wf-recorder; then 
    notify-send "Recording saved"
    sleep 0.5
    pkill -RTMIN+1 waybar
    exit 0
fi

# start recording
wf-recorder --audio=$(pactl get-default-sink).monitor -f "$(xdg-user-dir VIDEOS)/$(date +'%Y-%m-%d_%H-%M-%S').mp4" &

# refresh waybar indicator
sleep 0.5
pkill -RTMIN+1 waybar


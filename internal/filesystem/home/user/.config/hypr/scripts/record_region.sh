#!/bin/bash

# if already recording
if pkill wf-recorder; then 
    notify-send "Recording saved"
    sleep 0.5
    pkill -RTMIN+1 waybar
    exit 0
fi

# get geometry or exit
if ! geometry=$(slurp -b 000000b3 -c ff0000a0); then
    notify-send "Recording cancelled"
    exit 0
fi

# start recording
wf-recorder --audio=$(pactl get-default-sink).monitor -g "$geometry" -f "$(xdg-user-dir VIDEOS)/$(date +'%Y-%m-%d_%H-%M-%S').mp4" &

# refresh waybar indicator
sleep 0.5
pkill -RTMIN+1 waybar

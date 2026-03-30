#!/bin/bash

YAD_PID=""

cleanup() {
    [[ -n "$YAD_PID" ]] && kill "$YAD_PID" 2>/dev/null
    exit 0
}

trap cleanup SIGINT SIGTERM EXIT

shutdown_icon=""
reboot_icon=""
sleep_icon=""
# lock_icon=""

yad --name="yad.power" \
    --button="${shutdown_icon} Shutdown:0" \
    --button="${reboot_icon} Reboot:1" \
    --button="${sleep_icon} Sleep:2" \
    --buttons-layout=center &

YAD_PID=$!

wait $YAD_PID
choice=$?

sleep 0.2

case $choice in
    0)
        systemctl poweroff
        ;;
    1)
        systemctl reboot
        ;;
    2)
        systemctl suspend
        ;;
    # 3)
    #     hyprlock
    #     ;;
esac

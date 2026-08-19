#!/bin/bash

shutdown_icon=""
reboot_icon=""
sleep_icon=""

yad --name="yad.power" \
    --button="${shutdown_icon}:0" \
    --button="${reboot_icon}:1" \
    --button="${sleep_icon}:2" \

choice=$?

case $choice in
    0) systemctl poweroff ;;
    1) systemctl reboot ;;
    2) systemctl suspend ;;
esac

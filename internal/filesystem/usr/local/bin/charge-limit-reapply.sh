#!/bin/bash

battery=$(cat /var/battery)
battery_path="/sys/class/power_supply/$battery"

limit=$(cat /var/charge-limit)
status_=$(cat $battery_path/status)
capacity=$(cat $battery_path/capacity)

if [ "$status_" = "Charging" ] && [ "$capacity" -ge "$limit" ]; then
    [[ "$limit" =~ ^[0-9]+$ ]] || exit 0
    /usr/local/bin/charge-limit $limit
fi

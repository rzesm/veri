#!/bin/bash

CONFIG="$HOME/.config/waybar/config.jsonc"

if [ ! -f "$CONFIG" ]; then
    exit 1
fi

HAS_WIFI=false
HAS_BT=false

[[ -n $(ls -d /sys/class/net/wl* 2>/dev/null) ]] && HAS_WIFI=true
[[ -n $(ls -d /sys/class/bluetooth/hci* 2>/dev/null) ]] && HAS_BT=true

# Toggle Wi-Fi
if [ "$HAS_WIFI" = true ]; then
    sed -i 's#//,"network"#,"network"#g' "$CONFIG"
else
    sed -i 's#//,"network"#,"network"#g' "$CONFIG"
    sed -i 's#,"network"#//,"network"#g' "$CONFIG"
fi

# Toggle Bluetooth
if [ "$HAS_BT" = true ]; then
    sed -i 's#//,"bluetooth"#,"bluetooth"#g' "$CONFIG"
else
    sed -i 's#//,"bluetooth"#,"bluetooth"#g' "$CONFIG"
    sed -i 's#,"bluetooth"#//,"bluetooth"#g' "$CONFIG"
fi

if pgrep -x "waybar" > /dev/null; then
    pkill -SIGUSR2 waybar
fi

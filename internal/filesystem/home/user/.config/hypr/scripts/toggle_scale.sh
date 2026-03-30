#!/bin/bash

scale=$(hyprctl monitors -j | jq -r '.[] | select(.focused==true) | .scale')

if [[ "$scale" == "1.88" ]]; then
    hyprctl keyword monitor , 2880x1800@120, 0x0, 1.25
else
    hyprctl keyword monitor , 2880x1800@120, 0x0, 1.875
fi

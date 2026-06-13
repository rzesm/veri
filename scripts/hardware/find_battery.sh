#!/bin/bash

# Finds a battery device BATX in /sys/class/power_supply

for bat in /sys/class/power_supply/*; do
    [[ ! -d "$bat" ]] && continue
    [[ ! "$(cat "$bat/type" 2>/dev/null)" == "Battery" ]] && continue

    if [[ "$(basename "$bat")" == BAT* ]]; then
        echo -e $(basename "$bat")
        exit 0
    fi
done
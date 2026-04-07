#!/bin/bash

bat="/sys/class/power_supply/$(cat /var/battery)"
capacity=$(cat $bat/capacity)

[[ ! -e "$bat/capacity" ]] && exit

# Choose glyph based on battery level
if [ "$capacity" -ge 80 ]; then
    glyph=""
elif [ "$capacity" -ge 60 ]; then
    glyph=""
elif [ "$capacity" -ge 40 ]; then
    glyph=""
elif [ "$capacity" -ge 20 ]; then
    glyph=""
else
    glyph=""
fi

# Output the glyph and percentage
echo "$glyph $capacity%"

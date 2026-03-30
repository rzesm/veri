#!/bin/bash

bat=$(cat /var/battery)

capacity=$(cat $bat/capacity)

if [[ ! -e "$bat/capacity" ]]; then
    exit
fi

# Choose glyph based on battery level
if [ "$capacity" -ge 80 ]; then
    glyph=""  # full battery
elif [ "$capacity" -ge 60 ]; then
    glyph=""  # 3/4 battery
elif [ "$capacity" -ge 40 ]; then
    glyph=""  # half battery
elif [ "$capacity" -ge 20 ]; then
    glyph=""  # 1/4 battery
else
    glyph=""  # empty battery
fi

# Output the glyph and percentage
echo "$glyph $capacity%"

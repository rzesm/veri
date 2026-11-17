#!/bin/bash

pkill rofi && exit

read -r x y < <(
    hyprctl -j monitors | jq -r '
        .[] | select(.focused == true) |
        [
            (.x + .width / (2 * .scale)),
            (.y + .height / (2 * .scale) - 170)
        ] | @tsv
    '
)

hyprctl dispatch "hl.dsp.cursor.move({ x = $x, y = $y })"

rofi -show drun

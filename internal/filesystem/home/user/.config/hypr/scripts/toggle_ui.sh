#!/bin/bash

if pgrep -x waybar >/dev/null; then 
    pkill waybar
    hyprctl eval 'hl.config({
        general = {
            gaps_out = 2,
            gaps_in = 1,
        },
        decoration = {
            rounding = 8,
            glow = {
                range = 18,
                render_power = 3
            }
        },

    })'
else
    waybar & disown
    hyprctl eval 'hl.config({
        general = {
            gaps_out = 10,
            gaps_in = 3,
        },
        decoration = {
            rounding = 20,
            glow = {
                range = 30,
                render_power = 4
            }
        },
    })'
fi


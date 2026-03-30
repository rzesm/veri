#!/usr/bin/env bash

aw_json=$(hyprctl activewindow -j)
is_floating=$(printf '%s' "$aw_json" | jq -r '.floating // "false"')

if [ "$is_floating" = "true" ]; then
    hyprctl dispatch settiled
else
    hyprctl dispatch setfloating
    hyprctl dispatch resizeactive exact 800 600
    hyprctl dispatch centerwindow
fi


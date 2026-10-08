#!/usr/bin/bash

CLASS="quick-terminal"

pkill -x resources

if hyprctl clients | grep -q "class: $CLASS"; then
    hyprctl dispatch "hl.dsp.window.close({ window = \"class:$CLASS\" })"
else
    kitty --class=quick-terminal
fi


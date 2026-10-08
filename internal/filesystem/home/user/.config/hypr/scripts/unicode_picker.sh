#!/usr/bin/bash

CLASS="unicode-picker"

if hyprctl clients | grep -q "class: $CLASS"; then
    hyprctl dispatch "hl.dsp.window.close({ window = \"class:$CLASS\" })"
else
    kitty --title="Unicode picker" --class="$CLASS" "$HOME/.config/hypr/scripts/unicode_input.sh" &
fi

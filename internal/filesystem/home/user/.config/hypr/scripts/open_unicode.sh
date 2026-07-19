#!/usr/bin/bash

CLASS="unicode-input"

if hyprctl clients | grep -q "class: $CLASS"; then
    hyprctl dispatch "hl.dsp.focus({ window = \"class:$CLASS\" })"
else
    kitty --title="Unicode picker" --class="$CLASS" "$HOME/.config/hypr/scripts/unicode_input.sh" &
fi

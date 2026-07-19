#!/usr/bin/bash

if pgrep -x "clipse-gui" > /dev/null; then
    hyprctl dispatch 'hl.dsp.focus({ window = "class:clipse-gui" })'
else
    clipse-gui &
fi

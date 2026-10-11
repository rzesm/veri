#!/bin/bash

# Fetch active workspace id and window count
read -r active_id num_windows < <(hyprctl -j activeworkspace | jq -r '[.id, .windows] | @tsv')

[[ "$num_windows" -lt 2 ]] && exit 0

# Get an empty workspace id
max_id=$(hyprctl -j workspaces | jq 'map(.id) | max')
target_ws=$(( max_id + 1 ))

hyprctl dispatch "hl.dsp.window.move({ workspace = $target_ws })"

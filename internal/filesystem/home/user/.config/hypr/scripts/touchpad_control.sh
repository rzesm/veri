#!/usr/bin/env bash

INTERVAL=0.05 # Sample rate in seconds
THRESH=1 # Minimum movement in pixels

# Parses hyprctl cursorpos
get_pos() {
   	local out nums
   	out=$(hyprctl cursorpos 2>/dev/null || echo "")
   	nums=($(echo "$out" | tr -d ',' | grep -oE '[-]?[0-9]+(\.[0-9]+)?' | sed -n '1,2p'))
   	echo "${nums[0]:-} ${nums[1]:-}"
}

cleanup() {
    # Restore cursor position
    hyprctl dispatch movecursor $original_x $original_y
    exit
}

read original_x original_y < <(get_pos)
trap cleanup SIGINT SIGTERM SIGQUIT

while true; do
   	hyprctl dispatch movecursor 800 500
   	read x1 y1 < <(get_pos)
   	sleep "$INTERVAL"
   	read x2 y2 < <(get_pos)
   
   	# Compute distance and angle
   	read distance angle < <(python3 - <<PY
import math
x1 = float($x1); y1 = float($y1)
x2 = float($x2); y2 = float($y2)
dx = x2 - x1
dy = y2 - y1
dist = math.hypot(dx, dy) / 2
ang = math.degrees(math.atan2(dx, -dy))
if ang < 0:
    ang += 360
print(f"{dist:.6f} {ang:.6f}")
PY
    )

   	if awk -v d="$distance" -v t="$THRESH" 'BEGIN{exit !(d >= t)}'; then
   	   	# Up
   	   	if awk -v a="$angle" 'BEGIN{exit !(a > 340 || a < 20)}'; then
   	   	    brightnessctl set ${distance}+
   	   	# Right
   	   	elif awk -v a="$angle" 'BEGIN{exit !(a > 70 && a < 110)}'; then
   	   	   	wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ $(echo "$distance / 3" | bc)%+
   	   	# Down
   	   	elif awk -v a="$angle" 'BEGIN{exit !(a > 160 && a < 200)}'; then
   	   	    brightnessctl set ${distance}-
   	   	# Left
   	   	elif awk -v a="$angle" 'BEGIN{exit !(a > 250 && a < 290)}'; then
   	   		   wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ $(echo "$distance / 3" | bc)%-
   	   	fi
   	fi

done

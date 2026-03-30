if pgrep -x waybar >/dev/null; then 
    pkill waybar
    # hyprctl keyword plugin:hyprbars:enabled false
    hyprctl keyword general:gaps_out 6
    hyprctl keyword general:gaps_in  3
    hyprctl keyword decoration:rounding 10
else
    waybar & disown
    # hyprctl keyword plugin:hyprbars:enabled true
    hyprctl keyword general:gaps_out 10
    hyprctl keyword general:gaps_in 5
    hyprctl keyword decoration:rounding 20
fi

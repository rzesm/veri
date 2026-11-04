#!/bin/bash

WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"
CURRENT_WALLPAPER="$HOME/.config/hypr/wallpaper"

mapfile -t WALLPAPERS < <(
    find "$WALLPAPER_DIR" -maxdepth 1 -type f | sort
)

SELECTED=$(
    for wallpaper in "${WALLPAPERS[@]}"; do
        name=$(basename "$wallpaper")
        printf '%s\0icon\x1f%s\n' "$name" "$wallpaper"
    done |
    rofi -dmenu \
        -i \
        -p "" \
        -show-icons \
        -theme-str '
            window {
                width: 650px;
            }
            listview {
                columns: 4;
                lines: 2;
                spacing: 12px;
                fixed-height: false;
            }
            element {
                orientation: vertical;
                border-radius: 10px;
                padding: 10px;
            }
            element-icon {
                size: 100px;
                horizontal-align: 0.5;
            }
        '
)

[[ -z "$SELECTED" ]] && exit 0

WALLPAPER="$WALLPAPER_DIR/$SELECTED"

pkill swaybg
swaybg -i "$WALLPAPER" -m fill & disown

ln -sfn "$WALLPAPER" "$CURRENT_WALLPAPER"

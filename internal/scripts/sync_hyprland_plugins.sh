#!/bin/bash

echo "sync_hyprland_plugins.sh: syncing Hyprland plugins"

mkdir -p ~/.local/share/veri
cd ~/.local/share/veri || exit 1
rm -rf hyprland-plugins

git clone https://github.com/hyprwm/hyprland-plugins
cd hyprland-plugins
mkdir -p build
cmake -S . -B build
cmake --build build

echo "sync_hyprland_plugins.sh: finished syncing Hyprland plugins"
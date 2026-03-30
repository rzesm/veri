#!/bin/bash

# Important - create home files in .../home/user/... and not using $(whoami) 
username=$(whoami)

if [[ -f "internal/configured/hardware/battery" ]]; then
    mkdir -p internal/configured/filesystem/var
    echo -e $(cat internal/configured/hardware/battery) > internal/configured/filesystem/var/battery
    echo 100 > internal/configured/filesystem/var/charge-limit
fi

mkdir -p internal/configured/filesystem/etc/greetd
cat <<EOF >internal/configured/filesystem/etc/greetd/config.toml
[terminal]
vt = 1
[default_session]
command = "start-hyprland > /dev/null 2>&1"
user = "$(whoami)"
EOF

mkdir -p internal/configured/filesystem/home/user/.config/hypr
cat <<EOF >internal/configured/filesystem/home/user/.config/hypr/core.conf
############
### CORE ###
############

plugin = /home/$username/.local/share/veri/hyprland-plugins/build/hyprbars/libhyprbars.so
plugin = /home/$username/.local/share/veri/hyprland-plugins/build/hyprexpo/libhyprexpo.so

exec-once = hyprctl plugin load /home/$username/.local/share/veri/hyprland-plugins/build/hyprbars/libhyprbars.so
exec-once = hyprctl plugin load /home/$username/.local/share/veri/hyprland-plugins/build/hyprexpo/libhyprexpo.so
exec-once = clipse -listen
exec-once = waybar
exec-once = /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
exec-once = swayidle -w timeout 600 'poweroff'
exec-once = sleep 1.5 && hyprlock && pkill swayidle && swayidle -w timeout 600 'systemctl suspend' before-sleep 'hyprlock &'
EOF
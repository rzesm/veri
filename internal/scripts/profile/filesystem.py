import filecmp
import os
from pathlib import Path
from textwrap import dedent

from config import Config
from shell import sh

USERNAME = sh("whoami", capture=True).stdout.strip()
FILESYSTEM_PATH = "/tmp/veri-filesystem"

GREETD = f"""\
[terminal]
vt = 1
[default_session]
command = "start-hyprland > /dev/null 2>&1"
user = "{USERNAME}"
"""

CORE = f"""\
############
### CORE ###
############

plugin = /home/{USERNAME}/.local/share/veri/hyprland-plugins/build/hyprexpo/libhyprexpo.so

exec-once = hyprctl dispatch submap empty
exec-once = swaybg -i /home/{USERNAME}/.config/hypr/wallpaper -m fill
exec-once = sleep 1 && hyprlock && hyprctl dispatch submap reset && waybar
exec-once = clipse -listen
exec-once = /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
exec-once = swayidle -w timeout 600 'systemctl suspend' before-sleep 'hyprlock &'

submap = empty
bind = , _, submap, empty
submap = reset
"""

def remove_redundant():
    filesystem_path = Path(FILESYSTEM_PATH)
    root = Path("/")

    for internal_path in filesystem_path.rglob("*"):
        if not internal_path.is_file():
            continue

        device_path = root / internal_path.relative_to(filesystem_path)

        if device_path.is_file() and filecmp.cmp(internal_path, device_path, shallow=False):
            os.remove(internal_path)
    

def generate_filesystem(config: Config):
    sh(f"sudo rm -rf {FILESYSTEM_PATH}")

    # copy template
    sh(f"rsync -aHAX internal/filesystem/ {FILESYSTEM_PATH}/")
    
    # override placeholder username
    if USERNAME != "user":
        if os.path.exists(f"{FILESYSTEM_PATH}/home/{USERNAME}"):
            raise RuntimeError(f"{FILESYSTEM_PATH}/home/{USERNAME} exists")
        sh(f"mv -f {FILESYSTEM_PATH}/home/user {FILESYSTEM_PATH}/home/{USERNAME}")

    # generate specific files
    
    sh(f"mkdir -p {FILESYSTEM_PATH}/etc/greetd")
    open(f"{FILESYSTEM_PATH}/etc/greetd/config.toml", "w").write(GREETD)

    sh(f"mkdir -p {FILESYSTEM_PATH}/home/{USERNAME}/.config/hypr")
    open(f"{FILESYSTEM_PATH}/home/{USERNAME}/.config/hypr/core.conf", "w").write(CORE)

    
    # remove ignored files
    for file in config.ignored_files:
        sh(f"rm -rf {FILESYSTEM_PATH}{file}")
        
    remove_redundant()

    # fix permissions
    sh(f"sudo chown -R root {FILESYSTEM_PATH}")
    sh(f"sudo chgrp -R root {FILESYSTEM_PATH}")
    sh(f"sudo chown -R {USERNAME} {FILESYSTEM_PATH}/home/{USERNAME}")
    sh(f"sudo chgrp -R {USERNAME} {FILESYSTEM_PATH}/home/{USERNAME}")
    
    return FILESYSTEM_PATH
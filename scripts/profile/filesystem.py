import filecmp
import os
from pathlib import Path
from textwrap import dedent

from scripts.config import Config
from scripts.shell import sh

USERNAME = sh("whoami", capture=True).stdout.strip()
FILESYSTEM_PATH = "/tmp/veri-filesystem"

GREETD = f"""\
[terminal]
vt = 1
[default_session]
command = "start-hyprland > /dev/null 2>&1"
user = "{USERNAME}"
"""

USB_SOUNDS = f"""\
ACTION=="add", SUBSYSTEM=="usb", KERNEL=="*:1.0", RUN+="/usr/bin/systemctl --machine={USERNAME}@.host --user start usb-insert"
ACTION=="remove", SUBSYSTEM=="usb", KERNEL=="*:1.0", RUN+="/usr/bin/systemctl --machine={USERNAME}@.host --user start usb-remove"
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

    # generate files
    
    sh(f"mkdir -p {FILESYSTEM_PATH}/etc/greetd")
    open(f"{FILESYSTEM_PATH}/etc/greetd/config.toml", "w").write(GREETD)

    sh(f"mkdir -p {FILESYSTEM_PATH}/etc/udev/rules.d")
    open(f"{FILESYSTEM_PATH}/etc/udev/rules.d/99-usb-sounds.rules", "w").write(USB_SOUNDS)
    
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
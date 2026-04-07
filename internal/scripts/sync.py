import os

from profile.profile import Profile, generate_profile
from shell import sh
from runtime import ensure_runtime
from config import parse_config, generate_empty_config
from hardware.hardware import scan_hardware

def ask_to_generate_config():
    print("Would you like to generate an empty config? [Y/n] ", end="")
    if input().strip() not in ["y", "Y", ""]: exit(1)
    
    generate_empty_config()
    
    exit()
    
def print_changes(profile: Profile):
    if profile.packages:
        print("\nPackages that will be installed:")
        print(", ".join(profile.packages))
    if profile.services:
        print("\nServices that will be enabled:")
        print(", ".join(profile.services))
    if profile.gsettings:
        print("\nGsettings that will be set:")
        strings = [' '.join(gsetting) for gsetting in profile.gsettings]
        print("\n".join(strings))
    print("\nFiles that will be modified:")
    sh(f"tree -a --prune {profile.filesystem_path}")
    print()

def main():
    ensure_runtime() or exit(1)

    config = parse_config() or ask_to_generate_config()
    hardware = scan_hardware()
    profile = generate_profile(config, hardware)

    print_changes(profile)
    print("Proceed with update? [Y/n] ", end="")
    if input().strip() not in ["y", "Y", ""]: exit(1)
    
    # update system
    if "nosyu" not in config.flags:
        sh("yay --noconfirm")

    # install packages
    sh(f"yay -S --needed --noconfirm {" ".join(profile.packages)}")

    # enable services
    for service in profile.services:
        sh(f"sudo systemctl enable {service}")

    # copy files
    sh(f"sudo rsync -aHAX --backup --suffix=.bak {profile.filesystem_path}/ /")
    
    # set gsettings
    for gsetting in profile.gsettings:
        sh(f"dbus-run-session gsettings set {" ".join(gsetting)}")

    # change shell
    if "nozsh" not in config.flags:
        sh("sudo chsh -s /usr/bin/zsh $username")
        
    # sync hyprland plugins
    if "noplugins" not in config.flags:
        sh("internal/scripts/sync_hyprland_plugins.sh")
        
    # clean up
    sh(f"sudo rm -rf {profile.filesystem_path}")
    
    print("sync.py: synchronisation finished")
    
if __name__ == "__main__":
    main()
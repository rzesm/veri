import os

from scripts.profile.profile import Profile, generate_profile
from scripts.shell import sh
from scripts.runtime import ensure_runtime
from scripts.config import parse_config, generate_empty_config
from scripts.hardware.hardware import scan_hardware

def ask_to_generate_config():
    print("Would you like to generate an empty config? [Y/n] ", end="")
    if input().strip() not in ["y", "Y", ""]: exit(1)
    
    generate_empty_config()
    
    exit()
    
def get_available_package_version(name):
    return sh(
        f"LC_ALL=C yay -Si {name} | sed -n 's/^Version\\s*:\\s*//p'",
        capture=True).stdout.strip()

def print_changes(profile: Profile):
    if profile.packages_versions:
        version_mismatches = 0
        print("\nPackages that will be installed:")
        for (package, required_version) in profile.packages_versions:
            available_version = get_available_package_version(package)
            if not required_version or (available_version == required_version):
                print(f"- {package} {available_version}")
            else:
                version_mismatches += 1
                print(f"- {package} {available_version} ({required_version} required)")
        if version_mismatches:
            print(
                f"Some packages are available with newer versions than required. "
                "They should not cause issues, but keep them in mind if something breaks. "
                "Downgrading or modifying configuration files may be required."
            )

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
    sh(f"yay -S --needed --noconfirm {" ".join(profile.packages_versions)}")

    # enable services
    for service in profile.services:
        sh(f"sudo systemctl enable {service}")

    # copy files
    sh(f"sudo rsync -aHAXP --backup --suffix=.bak {profile.filesystem_path}/ /")
    
    # set gsettings
    for gsetting in profile.gsettings:
        sh(f"dbus-run-session gsettings set {" ".join(gsetting)}")

    # change shell
    if "nozsh" not in config.flags:
        sh("sudo chsh -s /usr/bin/zsh $username")
        
    # clean up
    sh(f"sudo rm -rf {profile.filesystem_path}")
    
    print("sync.py: synchronisation finished")
    
if __name__ == "__main__":
    main()
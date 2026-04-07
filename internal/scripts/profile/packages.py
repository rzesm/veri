import os

from config import Config, parse_values
from hardware.hardware import Hardware
from shell import sh

def remove_redundant(packages: list[str]):
    output = []

    for package in packages:
        # if package is not installed
        if sh(f"sudo pacman -Q {package}", capture=True).returncode != 0:
            output.append(package)
            
    return output

def generate_packages(config: Config, hardware: Hardware):
    base_packages = parse_values(open("internal/packages"))
    ignored_packages = config.ignored_packages
    hardware_packages = []

    if hardware.battery:
        hardware_packages.append("tlp")
        
    if hardware.gpu == "intel":
        hardware_packages.append("vulkan-intel")
        hardware_packages.append("lib32-vulkan-intel")
    elif hardware.gpu == "amd":
        hardware_packages.append("vulkan-radeon")
        hardware_packages.append("lib32-vulkan-radeon")
    elif hardware.gpu == "nvidia_modern":
        hardware_packages.append("nvidia-open-dkms")
        hardware_packages.append("nvidia-utils")
        hardware_packages.append("lib32-nvidia-utils")
    elif hardware.gpu == "nvidia_legacy":
        hardware_packages.append("nvidia-580xx-dkms")
        hardware_packages.append("nvidia-580xx-utils")
        hardware_packages.append("lib32-nvidia-580xx-utils")
        
    final_packages = list(set(base_packages + hardware_packages) - set(ignored_packages))
    final_packages.sort()

    return remove_redundant(final_packages)
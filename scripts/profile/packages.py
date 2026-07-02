import os
from typing import TextIO

from scripts.config import Config
from scripts.hardware.hardware import Hardware
from scripts.shell import sh

def parse_packages_versions(file: TextIO) -> list[str]:
    values = []

    for line in file:
        line = line.strip()
        if line.startswith('#'): continue
        
        items = line.split()
        if len(items) == 1: values.append((items[0], None))
        else: values.append((items[0], items[1]))
        
    return values

def remove_redundant(packages: list[str]):
    output = []

    for package in packages:
        # if package is not installed
        if sh(f"sudo pacman -Q {package}", capture=True).returncode != 0:
            output.append(package)
            
    return output

def generate_packages(config: Config, hardware: Hardware):
    base_packages_versions = parse_packages_versions(open("internal/packages"))
    base_packages = [item[0] for item in base_packages_versions]

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
        
    configured_packages = list(set(base_packages + hardware_packages) - set(ignored_packages))
    configured_packages.sort()
    final_packages = remove_redundant(configured_packages)
    
    version_lookup = dict(base_packages_versions)
    
    final_packages_versions = [
        (package, version_lookup.get(package, None)) for package in final_packages
    ]

    return final_packages_versions
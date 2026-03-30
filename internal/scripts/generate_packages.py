import os

def parse_packages(file_path) -> list[str]:
    packages = []

    for line in open(file_path):
        line = line.strip()

        if not line or line.startswith("#"): continue

        packages.append(line)
        
    return packages

base_packages = parse_packages("internal/packages")
ignored_packages = parse_packages(os.path.expanduser("~/.config/veri/ignore/packages.conf"))

hardware_packages = []

if os.path.exists("internal/configured/hardware/battery"):
    hardware_packages.append("tlp")
    
if os.path.exists("internal/configured/hardware/gpu"):
    gpu = open("internal/configured/hardware/gpu").read().strip()
    
    if gpu == "intel":
        hardware_packages.append("vulkan-intel")
        hardware_packages.append("lib32-vulkan-intel")
    elif gpu == "amd":
        hardware_packages.append("vulkan-radeon")
        hardware_packages.append("lib32-vulkan-radeon")
    elif gpu == "nvidia-modern":
        hardware_packages.append("nvidia-open-dkms")
        hardware_packages.append("nvidia-utils")
        hardware_packages.append("lib32-nvidia-utils")
    elif gpu == "nvidia-legacy":
        hardware_packages.append("nvidia-580xx-dkms")
        hardware_packages.append("nvidia-580xx-utils")
        hardware_packages.append("lib32-nvidia-580xx-utils")

final_packages = list(set(base_packages + hardware_packages) - set(ignored_packages))
final_packages.sort()

output = open("internal/configured/packages", "w")
output.write("\n".join(final_packages))
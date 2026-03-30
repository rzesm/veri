import os

def parse_services(file_path) -> list[str]:
    packages = []

    for line in open(file_path):
        line = line.strip()

        if not line or line.startswith('#'): continue

        packages.append(line)
        
    return packages

base_services = parse_services("internal/services")
ignored_services = parse_services(os.path.expanduser("~/.config/veri/ignore/services.conf"))

hardware_services = []

if os.path.exists("internal/configured/hardware/battery"):
    hardware_services.append("tlp")
    hardware_services.append("charge-limit-reapply.timer")

final_services = list(set(base_services + hardware_services) - set(ignored_services))
final_services.sort()

output = open("internal/configured/services", 'w')
output.write('\n'.join(final_services))
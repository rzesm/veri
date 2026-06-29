import os
from typing import TextIO

from scripts.config import Config
from scripts.hardware.hardware import Hardware
from scripts.shell import sh

def parse_values(file: TextIO) -> list[str]:
    values = []

    for line in file:
        line = line.strip()
        if line.startswith('#'): continue
        values.append(line)

    return values 

def remove_redundant(services: list[str]):
    output = []

    for service in services:
        # if service is not enabled
        if sh(f"systemctl is-enabled --quiet {service}").returncode != 0:
            output.append(service)
    
    return output

def generate_services(config: Config, hardware: Hardware):
    base_services = parse_values(open("internal/services"))
    ignored_services = config.ignored_services
    hardware_services = []

    if hardware.battery:
        hardware_services.append("tlp")
        hardware_services.append("charge-limit-reapply.timer")

    final_services = list(set(base_services + hardware_services) - set(ignored_services))
    final_services.sort()
    
    return remove_redundant(final_services)
import os

from config import Config, parse_values
from hardware.hardware import Hardware
from shell import sh

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
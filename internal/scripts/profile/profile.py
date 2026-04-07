from dataclasses import dataclass

from config import Config
from hardware.hardware import Hardware
from shell import sh
from profile.packages import generate_packages
from profile.services import generate_services
from profile.gsettings import generate_gsettings
from profile.filesystem import generate_filesystem

@dataclass
class Profile:
    packages: list[str]
    services: list[str]
    gsettings: list[str]
    filesystem_path: str

def generate_profile(config: Config, hardware: Hardware):
    print("profile.py: generating installation profile")
    
    packages = generate_packages(config, hardware)
    services = generate_services(config, hardware)
    gsettings = generate_gsettings(config)
    filesystem_path = generate_filesystem(config)
    
    return Profile(packages, services, gsettings, filesystem_path)
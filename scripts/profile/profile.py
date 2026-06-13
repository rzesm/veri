from dataclasses import dataclass

from scripts.config import Config
from scripts.hardware.hardware import Hardware
from scripts.shell import sh
from scripts.profile.packages import generate_packages
from scripts.profile.services import generate_services
from scripts.profile.gsettings import generate_gsettings
from scripts.profile.filesystem import generate_filesystem

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
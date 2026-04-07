import os
from dataclasses import dataclass
from enum import Enum
from shell import sh

from hardware.gpu import find_gpu

class GPUType(Enum):
    amd = "amd"
    intel = "intel"
    nvidia_modern = "nvidia_modern"
    nvidia_legacy = "nvidia_legacy"

@dataclass
class Hardware:
    battery: str = None
    gpu: str = None
    
CACHE_DIR = os.path.expanduser("~/.cache/veri/hardware")

def cache_exists(key: str):
    return os.path.exists(f"{CACHE_DIR}/{key}")

def read_cache(key: str):
    cache_file = f"{CACHE_DIR}/{key}"
    if os.path.exists(cache_file):
        return open(cache_file).read()

def write_cache(key: str, value: str):
    open(f"{CACHE_DIR}/{key}", "w").write(value)

def scan_hardware():
    hardware = Hardware()

    # look for previously found hardware in ~/.cache/veri/hardware
    battery_cached = cache_exists("battery")
    gpu_cached = cache_exists("gpu")
    
    # if there's a missing cache file
    if not battery_cached or not gpu_cached:
        print("hardware.py: detecting hardware")

    sh(f"mkdir -p {CACHE_DIR}")

    # get battery
    if battery_cached:
        hardware.battery = read_cache("battery")
    else:
        hardware.battery = sh("internal/scripts/hardware/find_battery.sh", capture=True).stdout.strip()
        write_cache("battery", hardware.battery)

        if hardware.battery: print(f"hardware.py: found internal battery {hardware.battery}")
        else: print("hardware.py: no internal battery was found")

    # get gpu
    if gpu_cached:
        hardware.gpu = read_cache("gpu")
    else:
        hardware.gpu = find_gpu()
        write_cache("gpu", hardware.gpu)

        if hardware.gpu: print(f"hardware.py: found {hardware.gpu} GPU")
        else: print("hardware.py: no GPU was found")
    
    return hardware
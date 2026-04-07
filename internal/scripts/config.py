from dataclasses import dataclass, field
import os
from textwrap import dedent
from typing import TextIO

from shell import sh

@dataclass
class Config:
    ignored_files: list[str] = None
    ignored_services: list[str] = None
    ignored_packages: list[str] = None
    ignored_gsettings: list[(str, str)] = None
    flags: list[str] = None
    
def parse_values(file: TextIO) -> list[str]:
    values = []

    for line in file:
        line = line.strip()
        if line.startswith('#'): continue
        values.append(line)
        
    return values
    
def parse_gsettings(file: TextIO):
    gsettings = []

    for line in file:
        line = line.strip()
        if line.startswith('#'): continue
        gsettings.append(tuple(line.split(' ', 1)))

    return gsettings
    
def parse_config():
    print("config.py: loading config from ~/.config/veri")

    try:
        config = Config()
        
        config.flags = parse_values(open(os.path.expanduser("~/.config/veri/flags.conf"), "r"))
        config.ignored_files = parse_values(open(os.path.expanduser("~/.config/veri/ignore/files.conf"), "r"))
        config.ignored_services = parse_values(open(os.path.expanduser("~/.config/veri/ignore/services.conf"), "r"))
        config.ignored_packages = parse_values(open(os.path.expanduser("~/.config/veri/ignore/packages.conf"), "r"))
        config.ignored_gsettings = parse_gsettings(open(os.path.expanduser("~/.config/veri/ignore/gsettings.conf"), "r"))
        
        return config
    except Exception as e:
        print(f"config.py: error: failed to parse config, the installer will exit: {e}")
        return None
    
def generate_empty_config():
    FLAGS = dedent("""\
        # Extra flags to apply during installation, separated by newlines
        # Here's a list of available flags:
        # nozsh - skips changing the user's shell to zsh if applicable
        # nosyu - skips full system upgrade
        # noplugins - skips syncing Hyprland plugins
    """)

    FILES = dedent("""\
        # A list of paths of files to skip in the installation process, separated by newlines
        # Important: each path must be absolute, e.g. /home/user/.config/hypr/host.conf
        # Directories can also be included, just like regular files
    """)

    GSETTINGS = dedent("""\
        # A list of gsettings to skip in the installation process, separated by newlines
        # Each gsetting consists of a directory name and a setting name, separated by a space
    """)

    PACKAGES = dedent("""\
        # A list of names of packages to skip in the installation process, separated by newlines
    """)

    SERVICES = dedent("""\
        # A list of names of services to skip in the installation process, separated by newlines
    """)
    
    sh("rm -rf ~/.config/veri")
    sh("mkdir -p ~/.config/veri/ignore")
    open(os.path.expanduser("~/.config/veri/flags.conf"), "w").write(FLAGS)
    open(os.path.expanduser("~/.config/veri/ignore/files.conf"), "w").write(FILES)
    open(os.path.expanduser("~/.config/veri/ignore/gsettings.conf"), "w").write(GSETTINGS)
    open(os.path.expanduser("~/.config/veri/ignore/packages.conf"), "w").write(PACKAGES)
    open(os.path.expanduser("~/.config/veri/ignore/services.conf"), "w").write(SERVICES)
    
    print("config.py: generated an empty config at ~/.config/veri")
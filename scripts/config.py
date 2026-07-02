from dataclasses import dataclass, field
import os
import configparser
from textwrap import dedent

from scripts.shell import sh

@dataclass
class Config:
    ignored_files: list[str] = field(default_factory=list)
    ignored_services: list[str] = field(default_factory=list)
    ignored_packages: list[str] = field(default_factory=list)
    ignored_gsettings: list[tuple[str, str]] = field(default_factory=list) 
    flags: list[str] = field(default_factory=list)  
    
def parse_config():
    config_path = os.path.expanduser("~/.config/veri/installer.conf")
    print(f"config.py: loading config from {config_path}")

    if not os.path.exists(config_path):
        print("config.py: error: config file does not exist.")
        return None

    try:
        parser = configparser.ConfigParser(allow_no_value=True)
        
        # enable case sensitivity
        parser.optionxform = str 
        
        parser.read(config_path)
        config = Config()
        
        if parser.has_section("flags"):
            config.flags = parser.options("flags")
            
        if parser.has_section("ignored_files"):
            config.ignored_files = parser.options("ignored_files")
            
        if parser.has_section("ignored_services"):
            config.ignored_services = parser.options("ignored_services")
            
        if parser.has_section("ignored_packages"):
            config.ignored_packages = parser.options("ignored_packages")
            
        if parser.has_section("ignored_gsettings"):
            config.ignored_gsettings = [
                tuple(line.split(' ', 1)) for line in parser.options("ignored_gsettings") if ' ' in line
            ]
            
        return config
    except Exception as e:
        print(f"config.py: error: failed to parse config, the installer will exit: {e}")
        return None
        
def generate_empty_config():
    CONFIG_CONTENT = dedent("""\
        [flags]
        # Extra flags to apply during installation, each on a new line.
        # Uncomment a flag to enable it:
        # nozsh
        # nosyu
        # nowebapps

        [ignored_files]
        # A list of absolute paths of files or directories to skip.
        # Example: /home/user/.config/hypr/host.lua

        [ignored_services]
        # A list of names of systemd services to skip.

        [ignored_packages]
        # A list of names of packages to skip.

        [ignored_gsettings]
        # A list of gsettings to skip in the installation process.
        # Format: schema setting
        # Example: org.gnome.desktop.interface gtk-theme
    """)
    
    sh("mkdir -p ~/.config/veri") 

    config_path = os.path.expanduser("~/.config/veri/installer.conf")
    
    with open(config_path, 'w') as f:
        f.write(CONFIG_CONTENT)
        
    print(f"config.py: generated an empty config in {config_path}")
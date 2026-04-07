from config import Config, parse_values
from shell import sh

def remove_redundant(gsettings: list[(str, str, str)]):
    output = []

    for gsetting in gsettings:
        system_gsetting = sh(
            f"dbus-run-session gsettings get {gsetting[0]} {gsetting[1]}", capture=True
        ).stdout.strip().strip('\'')

        if system_gsetting != gsetting[2].strip('\''):
            output.append(gsetting)
            
    return output
    


def generate_gsettings(config: Config):
    base = parse_values(open("internal/gsettings"))
    base = [tuple(string.split(' ', 2)) for string in base]
        
    ignored_set = set(config.ignored_gsettings)
    final = [gsetting for gsetting in base if gsetting[:1] not in ignored_set]
    final.sort()
    
    return remove_redundant(final)
import os
import subprocess

for line in open(os.path.expanduser("~/.config/veri/ignore/files.conf")):
    line = line.strip()
    
    if not line or line.startswith("#"): continue
    
    if not line.startswith("/"):
        print("Error: invalid file path specified in config")
        exit()
    
    subprocess.run(["sudo", "rm", "-rf", f"internal/configured/filesystem{line}"])
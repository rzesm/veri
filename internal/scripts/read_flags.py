import os

for line in open(os.path.expanduser("~/.config/veri/flags.conf")):
    line = line.strip()

    if not line or line.startswith("#"): continue

    # Create the corresponding file
    open(f"internal/configured/flags/{line}", "w")
import sys

for line in sys.stdin:
    line = line.strip()
    
    if any(line.startswith(w) for w in ["sending", "sent", "total"]) or not line:
        continue

    details, name = line.split(' ', 1)
    metadata_changes = details[3:].replace('.', '')

    if details.endswith('+'):
        print(f"[{details}] Create     /{name}")
    
    elif details.startswith('>'):
        print(f"[{details}] Overwrite  /{name}")
    elif details.startswith('.') and metadata_changes:
        print(f"[{details}] Modify     /{name}")
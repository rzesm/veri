import os

base = []
for line in open("internal/gsettings"):
    line = line.strip()
    
    if not line or line.startswith('#'): continue
    
    base.append(tuple(line.split(maxsplit=2)))

ignored = []
for line in open(os.path.expanduser("~/.config/veri/ignore/gsettings.conf")):
    line = line.strip()

    if not line or line.startswith('#'): continue
    
    ignored.append(tuple(line.split(maxsplit=1)))
    
ignored_set = set(ignored)
final_gsettings = [gsetting for gsetting in base if gsetting[:2] not in ignored_set]
final_gsettings.sort()

strings = [' '.join(gsetting) for gsetting in final_gsettings]
output = open("internal/configured/gsettings", 'w')
output.write('\n'.join(strings))
import subprocess

def sh(command: str, capture=False) -> subprocess.CompletedProcess[bytes]: 
    return subprocess.run(command, shell=True, text=True, capture_output=capture)
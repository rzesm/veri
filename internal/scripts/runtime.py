from shell import sh

def ensure_sudo():
    # check access
    if sh("sudo -v").returncode == 0: return True
    
    print("runtime.py: sudo failed, setting up sudo; you will need to enter root password a few times")
    
    # install sudo
    if sh("su -c 'pacman -S --needed sudo'").returncode != 0:
        print("runtime.py: error: failed to install sudo")
        exit()

    # add user to wheel
    username = sh(f"whoami", capture=True).stdout.strip()
    if sh(f"su -c 'usermod -aG wheel {username}'").returncode != 0:
        print("runtime.py: error: failed to add user to wheel")
        exit()

    # add wheel to sudoers
    if (sh(f"su -c \"echo '%wheel ALL=(ALL:ALL) ALL' | tee /etc/sudoers.d/10-wheel\"",).returncode != 0):
        print("runtime.py: error: failed to write to /etc/sudoers.d/10-wheel")
        exit()
    
    print("runtime.py: finished setting up sudo, please relogin and run the script again")
    exit()

def ensure_packages(packages: list[str]):
    needed_packages = []
    for package in packages:
        if sh(f"sudo pacman -Q {package}", capture=True).returncode != 0:
            needed_packages.append(needed_packages)
    sync = sh(f"sudo pacman -S --needed {" ".join(packages)}")
    if sync.returncode != 0:
        print(f"runtime.py: error: failed to install runtime dependencies")
        return False

    print(f"runtime.py: installed runtime dependencies")
    return True
        
def ensure_aur():
    ping = sh("curl -fsS --max-time 5 https://aur.archlinux.org/", capture=True)
    if ping.returncode != 0:
        print("runtime.py: error: failed to connect to aur.archlinux.org")
        return False
    return True

def ensure_repository(repository: str):
    # check if already enabled
    if sh(f"pacman-conf --repo-list | grep -q {repository}").returncode == 0:
        return True

    # uncomment section
    sh(f"sudo sed -i '/^\\[{repository}\\]/,/^Include/ s/^#//' /etc/pacman.conf")

    sh("sudo pacman -Syu")

    # verify
    if sh(f"pacman-conf --repo-list | grep -q {repository}").returncode != 0:
        print(f"runtime.py: error: failed to enable {repository}, try editing /etc/pacman.conf manually")
        return False

    print(f"runtime.py: enabled the {repository} repository in /etc/pacman.conf")
    return True

def ensure_yay():
    # check if yay is already installed
    if sh("command -v yay", capture=True).returncode == 0:
        return True

    build_dir = "/tmp/yay-build"
    sh(f"rm -rf {build_dir}")
    
    # clone yay
    if sh(f"git clone https://aur.archlinux.org/yay.git {build_dir}").returncode != 0:
        print("runtime.py: error: failed to clone yay repository")
        return False

    # build and install
    if sh(f"cd {build_dir} && GOFLAGS='-buildvcs=false' makepkg -si --noconfirm").returncode != 0:
        print("runtime.py: error: failed to build and install yay")
        return False

    # verify
    if sh("command -v yay").returncode != 0:
        print("runtime.py: error: failed to install yay")
        return False

    print("runtime.py: installed yay")
    return True

def ensure_runtime():
    print("runtime.py: verifying installer runtime")

    return \
        ensure_sudo() and \
        ensure_repository("extra") and \
        ensure_repository("multilib") and \
        ensure_packages(["rsync", "tree", "git"]) and \
        ensure_aur() and \
        ensure_yay()

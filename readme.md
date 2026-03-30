# Installation guide

The installer is meant for a fresh Arch Linux installation. It is possible to install Veri on top of a different existing environment, although things may and will break.

The best way to install Veri is from within the live environment, after `arch-chroot` has been run. During that phase some of the prerequisites will be already met.

### Prerequisites

1. Internet connection

    An internet connection is required to download packages during the installation. It is recommended to use iwd (https://wiki.archlinux.org/title/Iwd) or a wired connection. The installed environment will use iwd as backend so NetworkManager is not recommended.

2. The installer itself

    Once an internet connection has been estabilished, the installer can be cloned from Github. First install Git:

    `pacman -S git`
    
    Then clone the repository:
    
    `git clone https://github.com/rzesm/veri`

3. User account

    A non-root user account must be set up to run the installer scripts:

    `useradd -m <username>`
    
4. Sudo

    Sudo is required by the installer to elevate privileges:

    `pacman -S sudo`

5. rsync

    Rsync is used by the installer internally:

    `pacman -S rsync`

6. Yay

    The installer uses Yay (https://github.com/Jguer/yay#Installation) to install packages. It must be installed by following the instructions from the link above.
    
7. Multilib

    The multilib repository must be enabled as it contains some packages required by the installer.

    To enable it, first open `/etc/pacman.conf` and uncomment the following lines (by removing `#`):

    ```
    # [multilib]
    # Include = /etc/pacman.d/mirrorlist
    ```

    If you cannot find these lines, add them to the config.

8. Kernel parameters

    It is recommended to add kernel parameters that will make the boot experience cleaner (no console output, a fancy animation instead)
    
    The minimal recommended parameters are `quiet` and `splash`.
    
    Unfortunately this step depends on how you have installed Arch Linux. Below is an example from a boot entry for systemd-boot:
    
    `options root=/dev/<root partition> rw loglevel=3 quiet splash systemd.show_status=false rd.udev.log_level=3 vt.global_cursor_default=0`

### Using the installer

After fulfilling the prerequisites, locate the installer's folder. Inside you will find the `scripts` folder, which contains user-runnable commands that lead the installation process. The scripts must be run from the installer's root folder by a normal user, e.g.: `scripts/configure-installation`.

#### Scripts

The scripts are listed in order that an installation should normally follow.

1. `configure-installation`

    If no configuration exists, creates one at `~/.config/veri` and exits. Then you may edit the files to customize your installation. Once that is done (or not), you can run the command again to generate an installation fitted to your machine, enabling other scripts to be run.
    
2. `compare-files`

    Simply prints a list of system configuration files on your machine that will be affected by installing Veri. If any files which you do not want overwritten appear here, add them to `~/.config/veri/ignore/files`
    
3. `sync-packages`

    This is the first script which directly affects your machine. It downloads the configured list of packages.
    
4. `sync-config`

    Copies the system configuration files, and applies other miscellaneous changes to the system. Everything can be configured, see previous steps.
    
5. `sync-hyprland-plugins`

    Fetches and builds the latest Hyprland plugins.

#### Finishing up

After running the scripts above without encountering issues, you can finally reboot the system in hope of a successful installation.

### Maintaining the system

It is completely fine to maintain the system as any other Arch Linux installation. However, I recommend you occasionally upgrade Veri by pulling the latest installer and use the scripts to install available updates.

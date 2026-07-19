![](assets/veri_wide.png)

Veri is a minimal but polished and visually pleasing setup on top of Arch Linux and Hyprland. It is aimed at experienced users who need freedom, but also value their time. The project's policy and architecture support tweaking every single aspect of an Arch Linux system, while providing a stable baseline for the configuration of a modern desktop.

![](assets/desktop.png)

### Notable features

- Complete minimal desktop largely based on GTK apps
- Extensive and convenient system navigation
- Unified search (applications, shell, web search, and calculator), powered by Rofi
- Shell setup powered by Zsh
- Multiple touchpad gestures, including volume and screen brightness control
- Desktop level zoom
- Screenshot tool with text recognition
- Instant web app setup based on Zen browser
- Control over charging for laptop batteries
- Clipboard history with images
- Emoji and unicode picker

### Notice

Due to Arch Linux' nature things may change over time or break, affecting this project. There is no all time guarantee of stability of new installs, however I will attempt to deliver hotfixes as quickly as possible.

# Installation guide

The installer is meant for a fresh Arch Linux installation. It is possible to install Veri on top of a different environment, although things may and will break.

### Prerequisites

1. **Internet connection**

    An internet connection is required to download packages during the installation. It is recommended to use [iwd](https://wiki.archlinux.org/title/Iwd) for wireless connection. The installed environment will use iwd as backend.

2. **User account**

    A non-root user account must be set up to run the installer scripts.    

3. **The installer itself**

    Once internet connection and a user account are set up, make sure to switch to the user and then run:

    ```
    curl -L https://api.github.com/repos/rzesm/veri/tarball/main -o veri.tar.gz && tar -xzf veri.tar.gz
    ```
    
    This will put the installer in a folder in the current directory.

4. **Kernel parameters (recommended)**

    Add kernel parameters that will make the boot cleaner, particularly `quiet` and `splash`. How it's done depends on your bootloader. Here's an example with [systemd-boot](https://wiki.archlinux.org/title/Systemd-boot):
    
    ```
    options root=<UUID> rw loglevel=3 quiet splash systemd.show_status=false rd.udev.log_level=3 vt.global_cursor_default=0
    ```

### Using the installer

Run the `sync` script from the installer's directory, which will guide you through the installation. Reboot your computer afterwards.

### Maintaining the system

Once installed, updating Veri is possible via the `update-veri` command, which allows for pulling upstream features and fixes. Besides that, traditional maintenance methods of Arch Linux also apply and are sufficient. 

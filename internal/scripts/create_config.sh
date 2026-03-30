#!/bin/bash

mkdir -p ~/.config/veri/ignore

cat <<EOF >~/.config/veri/flags.conf
# Extra flags to apply during installation, separated by newlines
# Here's a list of available flags:
# nozsh - skips changing the user's shell to zsh if applicable (sync-config)
# nowheel - skips adding the user to wheel if applicable (sync-config)
# nosyu - skips full system upgrade (sync-packages)
EOF

cat <<EOF >~/.config/veri/ignore/files.conf
# A list of paths of files to skip in the installation process, separated by newlines
# Important: each path must be absolute, e.g. /home/user/.config/hypr/host.conf
# Directories can also be included, just like regular files
EOF

cat <<EOF >~/.config/veri/ignore/gsettings.conf
# A list of gsettings to skip in the installation process, separated by newlines
# Each gsetting consists of a directory name and a setting name, separated by a space
EOF

cat <<EOF >~/.config/veri/ignore/packages.conf
# A list of names of packages to skip in the installation process, separated by newlines
EOF

cat <<EOF >~/.config/veri/ignore/services.conf
# A list of names of services to skip in the installation process, separated by newlines
EOF


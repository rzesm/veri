export PATH="$HOME/bin:$HOME/.local/share/veri/bin:$PATH"
export HYPRSHOT_DIR="$HOME/captures"
export SUDO_ASKPASS="$HOME/.config/hypr/scripts/askpass.sh"

if [ -f "$HOME/.profile.local" ]; then
    . "$HOME/.profile.local"
fi

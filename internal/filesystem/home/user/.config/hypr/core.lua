-- CORE

hl.env("XCURSOR_THEME", "Adwaita")
hl.env("XCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
hl.env("GDK_WAYLAND_DISABLE", "ext_background_effect_manager_v1")

hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = "auto",
})

hl.define_submap("lock", function() 
    hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client --output-volume raise"), { locked = true, repeating = true })
    hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client --output-volume lower"), { locked = true, repeating = true })
    hl.bind("XF86AudioMute", hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"), { locked = true, repeating = true })
    hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle"), { locked = true, repeating = true })
    hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("swayosd-client --brightness raise"), { locked = true, repeating = true })
    hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness lower --min-brightness 0"), { locked = true, repeating = true })
end)

hl.on("hyprland.start", function()
    hl.dispatch(hl.dsp.submap("lock"))
    hl.exec_cmd("swaybg -i $HOME/.config/hypr/wallpaper -m fill")
    hl.exec_cmd("systemctl --user start hyprland-session.target")
    hl.exec_cmd("$HOME/.config/hypr/scripts/update_waybar.sh")
    hl.exec_cmd("sleep 1 && hyprlock && hyprctl dispatch 'hl.dsp.submap(\"reset\")' && waybar")
    hl.exec_cmd("clipse -listen")
    hl.exec_cmd("wl-clip-persist --clipboard regular")
    hl.exec_cmd("swayosd-server --top-margin 0.993")
    hl.exec_cmd("sleep 1 && /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("swayidle -w timeout 600 'systemctl suspend' before-sleep 'hyprlock &'")
    hl.exec_cmd("hyprpm reload")
    hl.exec_cmd("dbus-update-activation-environment --systemd GDK_WAYLAND_DISABLE")
end)

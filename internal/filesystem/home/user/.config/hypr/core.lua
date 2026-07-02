-- CORE

hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = "auto",
})

hl.define_submap("empty", function() 
    hl.bind("SUPER", function() end)
end)

hl.on("hyprland.start", function()
    hl.dispatch(hl.dsp.submap("empty"))
    hl.exec_cmd("swaybg -i $HOME/.config/hypr/wallpaper -m fill")
    hl.exec_cmd("systemctl --user start hyprland-session.target")
    hl.exec_cmd("sleep 1 && hyprlock && hyprctl dispatch 'hl.dsp.submap(\"reset\")' && waybar")
    hl.exec_cmd("clipse -listen")
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("swayidle -w timeout 600 'systemctl suspend' before-sleep 'hyprlock &'")
    hl.exec_cmd("hyprexpose --allow-mouse")
end)

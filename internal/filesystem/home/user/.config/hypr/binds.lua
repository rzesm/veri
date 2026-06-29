-- KEYBINDINGS AND GESTURES

-- General

hl.bind("SUPER + U", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle_ui.sh"))
hl.bind("SUPER + Tab", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle_overview.sh"))

hl.bind("SUPER + PRINT", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot_screen.sh"))
hl.bind("SUPER + S", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot_region.sh"))
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot_interactive.sh"))

hl.bind("SUPER + mouse_down", function()
    local current = hl.get_config("cursor.zoom_factor") or 1.0
    hl.config({ cursor = { zoom_factor = current * 1.1 } })
end)
hl.bind("SUPER + mouse_up", function()
    local current = hl.get_config("cursor.zoom_factor") or 1.0
    hl.config({ cursor = { zoom_factor = math.max(1.0, current / 1.1) } })
end)

hl.bind("SUPER + R", hl.dsp.exec_cmd("~/.config/hypr/scripts/record_screen.sh"))
hl.bind("SUPER + SHIFT + R", hl.dsp.exec_cmd("~/.config/hypr/scripts/record_region.sh"))

hl.bind("SUPER + SHIFT + F23", hl.dsp.exec_cmd("~/.config/hypr/scripts/touchpad_control.sh"))
hl.bind("SUPER + SHIFT + F23", hl.dsp.exec_cmd("pkill -SIGTERM -f ~/.config/hypr/scripts/touchpad_control.sh"), { release = true })

-- Apps

hl.bind("SUPER + C", hl.dsp.exec_cmd("kitty"))
hl.bind("SUPER + Q", hl.dsp.exec_cmd("pkill --exact rofi || hyprctl dispatch 'hl.dsp.window.close()'"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("nautilus -w"))
hl.bind("SUPER + Space", hl.dsp.exec_cmd("pkill --exact rofi || rofi -show drun"))
hl.bind("SUPER + I", hl.dsp.exec_cmd("kitty --app-id=neovim nvim"))
hl.bind("SUPER + B", hl.dsp.exec_cmd("zen-browser"))
hl.bind("SUPER + V", hl.dsp.exec_cmd("pkill -x clipse-gui; clipse-gui"))
hl.bind("SUPER + Period", hl.dsp.exec_cmd("pkill unicode_input; kitty --title=\"Unicode picker\" --class=unicode-input ~/.config/hypr/scripts/unicode_input.sh"))
hl.bind("SUPER + T", hl.dsp.exec_cmd("pkill -x btop || kitty --app-id=btop btop"))

-- Windows

hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind("SUPER + SHIFT + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
hl.bind("SUPER + X", hl.dsp.window.float({ action = "toggle" }))

hl.bind("SUPER + Left", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + Right", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + Up", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + Down", hl.dsp.focus({ direction = "down" }))
hl.bind("SUPER + H", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + L", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + K", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + J", hl.dsp.focus({ direction = "down" }))

hl.bind("SUPER + SHIFT + H", hl.dsp.window.swap({ direction = "l" }))
hl.bind("SUPER + SHIFT + L", hl.dsp.window.swap({ direction = "r" }))
hl.bind("SUPER + SHIFT + K", hl.dsp.window.swap({ direction = "u" }))
hl.bind("SUPER + SHIFT + J", hl.dsp.window.swap({ direction = "d" }))
hl.bind("SUPER + SHIFT + Left", hl.dsp.window.swap({ direction = "l" }))
hl.bind("SUPER + SHIFT + Right", hl.dsp.window.swap({ direction = "r" }))
hl.bind("SUPER + SHIFT + Up", hl.dsp.window.swap({ direction = "u" }))
hl.bind("SUPER + SHIFT + Down", hl.dsp.window.swap({ direction = "d" }))

hl.bind("SUPER + CONTROL + H", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + CONTROL + L", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + CONTROL + K", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
hl.bind("SUPER + CONTROL + J", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })
hl.bind("SUPER + CONTROL + Left", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + CONTROL + Right", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + CONTROL + Up", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
hl.bind("SUPER + CONTROL + Down", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })

hl.bind("SUPER + P", hl.dsp.layout("swapsplit"))
hl.bind("SUPER + O", hl.dsp.layout("togglesplit"))

hl.bind("SUPER + mouse:272", hl.dsp.window.drag())
hl.bind("SUPER + mouse:273", hl.dsp.window.resize())

-- Workspaces

hl.bind("SUPER + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind("SUPER + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind("SUPER + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind("SUPER + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind("SUPER + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind("SUPER + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind("SUPER + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind("SUPER + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind("SUPER + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind("SUPER + 0", hl.dsp.focus({ workspace = 10 }))
hl.bind("SUPER + A", hl.dsp.focus({ workspace = -1 }))
hl.bind("SUPER + D", hl.dsp.focus({ workspace = "+1" }))

hl.bind("SUPER + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind("SUPER + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind("SUPER + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind("SUPER + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind("SUPER + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
hl.bind("SUPER + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
hl.bind("SUPER + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
hl.bind("SUPER + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
hl.bind("SUPER + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))
hl.bind("SUPER + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))
hl.bind("SUPER + SHIFT + A", hl.dsp.window.move({ workspace = -1 }))
hl.bind("SUPER + SHIFT + D", hl.dsp.window.move({ workspace = "+1" }))

-- Function keys

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 4%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 4%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 5+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5-"), { locked = true, repeating = true })

-- Gestures

-- TODO

hl.gesture({
    fingers = 2,
    direction = "pinch",
    mods = "SUPER",
    action = "cursorZoom",
    zoom_level = 1,
    mode = "live"
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})

hl.gesture({
    fingers = 3,
    direction = "vertical",
    action = "fullscreen",
})

hl.gesture({
    fingers = 4,
    direction = "vertical",
    action = function()
        hl.exec_cmd("~/.config/hypr/scripts/toggle_overview.sh")
    end
})

hl.gesture({
    fingers = 4,
    direction = "pinch",
    action = function()
        hl.exec_cmd("pkill rofi || rofi -show drun")
    end
})

-- WINDOWS AND LAYERS

hl.layer_rule({
    match = { namespace = "wallpaper" },
    animation = "fade",
})

hl.layer_rule({
    match = { namespace = "waybar" },
    animation = "fade", blur = true, ignore_alpha = 0.1,
})

hl.layer_rule({
    match = { namespace = "rofi" },
    blur = true, ignore_alpha = 0, dim_around = true,
})

hl.layer_rule({
    match = { namespace = "hyprexpose" },
    animation = "slide bottom", blur = true,
})

hl.layer_rule({
    match = { namespace = "notifications" },
    blur = true, ignore_alpha = 0,
})

hl.layer_rule({
    match = { namespace = "wayfreeze" },
    no_anim = true,
})

hl.layer_rule({
    match = { namespace = "selection" },
    no_anim = true,
})

hl.layer_rule({
    match = { namespace = "hyprpicker" },
    no_anim = true,
})


hl.window_rule({
    name = "suppress-maximize-events",
    match = {
        class = ".*",
    },
    suppress_event = "maximize",
})

hl.window_rule({
    name = "fix-xwayland-drags",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    no_focus = true,
})

hl.window_rule({
    match = { class = "xdg-desktop-portal-gtk" },
    float = true,
    size = "600 400",
})

hl.window_rule({
    match = { class = "hyprland-share-picker" },
    float = true,
    size = "500 290",
})

-- Clipse
hl.window_rule({
    match = { class = "(clipse-gui)" },
    float = true,
    size = "460 500",
    move = "cursor_x-230 cursor_y-250",
})
hl.window_rule({
    match = {
        class = "(clipse-gui)",
        title = "(Keyboard Shortcuts)",
    },
    float = true,
    size = "634 500",
    move = "cursor_x-317 cursor_y-250",
})

-- Unicode
hl.window_rule({
    match = { class = "(unicode-input)" },
    float = true,
    size = "490 360",
    move = "cursor_x-245 cursor_y-180",
})

-- Qalculate
hl.window_rule({
    match = { class = "(qalculate-gtk)" },
    float = true,
    size = "415 265",
    move = "cursor_x-208 cursor_y-133",
})

-- Waybar widgets

-- Adwifi
hl.window_rule({
    match = { class = "(rzes.adwifi)" },
    animation = "slide",
    float = true,
    pin = true,
    size = "600 400",
    move = "monitor_w*0.5-300 40",
})

-- pwvucontrol                                      
hl.window_rule({
    match = { class = "(com.saivert.pwvucontrol)" },
    animation = "slide",
    float = true,
    pin = true,
    size = "900 600",
    move = "monitor_w*0.5-450 40",
})

-- Adwaita Bluetooth
hl.window_rule({
    match = {
        class = "(com.ezratweaver.AdwBluetooth)",
        title = "(Bluetooth)",
    },
    animation = "slide",
    float = true,
    pin = true,
    size = "600 400",
    move = "monitor_w*0.5-300 40",
})
-- This fixes a weird glitch that is beyond my comprehension
hl.window_rule({
    match = {
        class = "(com.ezratweaver.AdwBluetooth)",
        title = "(com.ezratweaver.AdwBluetooth)",
    },
    float = true,
    pin = true,
    size = "window_w-20 window_h-20",
    move = "monitor_w*0.5-(window_w-20)*0.5 monitor_h*0.5-(window_h-20)*0.5",
})

-- Power menu
hl.window_rule({
    match = { class = "(yad.power)" },
    animation = "slide",
    float = true,
    pin = true,
    size = "300 50",
    move = "monitor_w*0.5-150 40",
})

-- Charge limit menu
hl.window_rule({
    match = { class = "(yad.charge)" },
    animation = "slide",
    float = true,
    pin = true,
    size = "250 129",
    move = "5 40",
})

-- Calendar
hl.window_rule({
    match = { class = "(yad.calendar)" },
    animation = "slide",
    float = true,
    pin = true,
    size = "338 233",
    move = "monitor_w-344 40",
})

-- btop
hl.window_rule({
    match = { class = "(btop)" },
    animation = "slide",
    float = true,
    pin = true,
    size = "900 620",
    move = "monitor_w*0.5-450 monitor_h-620-5",
})

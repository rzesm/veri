-- INPUT SETTINGS

hl.config({
    input = {
        kb_layout = "pl",
        repeat_delay = 200,
        repeat_rate = 30,
        sensitivity = -0.2,
        follow_mouse = 1,
        touchpad = {
            scroll_factor = 0.15,
            natural_scroll = true,
            clickfinger_behavior = true,
            drag_3fg = 2,
        },
    },
    binds = {
        scroll_event_delay = 0,
    },
})

hl.window_rule({
    match = { class = "(kitty)" },
    scroll_touchpad = 1,
})

hl.window_rule({
    match = { class = "(neovim)" },
    scroll_touchpad = 1,
})

hl.window_rule({
    match = { class = "(unicode-input)" },
    scroll_touchpad = 1,
})

hl.window_rule({
    match = { class = "(org.gnome.Nautilus)" },
    scroll_touchpad = 0.5,
})

hl.window_rule({
    match = { class = "(code)" },
    scroll_touchpad = 0.3,
})

hl.window_rule({
    match = { class = "(com.saivert.pwvucontrol)" },
    scroll_touchpad = 0.1,
})

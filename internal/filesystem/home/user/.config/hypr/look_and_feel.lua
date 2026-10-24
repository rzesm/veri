-- LOOK AND FEEL

hl.curve("ease_out", { type = "bezier", points = { { 0.21, 0.61 }, { 0.35, 1.00 } } })
hl.curve("ease_out_exp", { type = "bezier", points = { { 0.19, 1.00 }, { 0.22, 1.00 } } })
hl.curve("ease_out_exp_springy", { type = "bezier", points = { { 0.19, 1.30 }, { 0.22, 0.96 } } })
hl.curve("ease_out_exp_little_springy", { type = "bezier", points = { { 0.16, 1.12 }, { 0.22, 1 } } })
hl.curve("ease_out_exp_very_springy", { type = "bezier", points = { { 0.19, 1.40 }, { 0.22, 0.93 } } })

hl.animation({
    leaf = "windows",
    enabled = true,
    speed = 3,
    bezier = "ease_out_exp_little_springy",
})
hl.animation({
    leaf = "windowsIn",
    enabled = true,
    speed = 3,
    bezier = "ease_out_exp_springy",
    style = "popin 50%",
})
hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = 3,
    bezier = "ease_out_exp",
    style = "popin 80%",
})
hl.animation({
    leaf = "layersIn",
    enabled = true,
    speed = 3,
    bezier = "ease_out_exp_very_springy",
    style = "popin 70%",
})
hl.animation({
    leaf = "layersOut",
    enabled = true,
    speed = 2,
    bezier = "ease_out_exp",
    style = "popin 90%",
})
hl.animation({
    leaf = "fadeOut",
    enabled = true,
    speed = 3,
    bezier = "ease_out",
})
hl.animation({
    leaf = "fadeLayers",
    enabled = true,
    speed = 4,
    bezier = "ease_out",
})
hl.animation({
    leaf = "fadeShadow",
    enabled = true,
    speed = 9,
    bezier = "ease_out",
})
hl.animation({
    leaf = "border",
    enabled = true,
    speed = 9,
    bezier = "ease_out",
})
hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 3,
    bezier = "ease_out_exp_little_springy",
})
hl.animation({
    leaf = "zoomFactor",
    enabled = true,
    speed = 3,
    bezier = "ease_out_exp"
})

hl.config({
    general = {
        gaps_in = 3,
        gaps_out = 10,
        border_size = 1,
        col = {
            active_border = { colors = { "rgba(ffffff55)", "rgba(ffffff22)" }, angle = 90 },
            inactive_border = "rgba(ffffff22)",
        },
        resize_on_border = true,
        allow_tearing = true,
        layout = "dwindle",
    },
    decoration = {
        rounding = 20,
        rounding_power = 2,
        active_opacity = 1,
        inactive_opacity = 1,
        shadow = {
            enabled = true,
            range = 10,
            render_power = 4,
            color = "rgba(00000077)",
            color_inactive = "rgba(00000000)",
        },
        blur = {
            enabled = true,
            size = 18,
            passes = 3,
            noise = 0.02,
        },
        glow = {
            enabled = true,
            range = 30,
            render_power = 4,
            color = 0x11ffffff,
            color_inactive = 0x00ffffff,
        },
    },
    dwindle = {
        preserve_split = true,
    },
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
    },
    gestures = {
        workspace_swipe_cancel_ratio = 0.2,
    },
    ecosystem = {
        no_donation_nag = true,
        no_update_news = true
    }
})


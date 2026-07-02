-- LOOK AND FEEL

hl.curve("linear", { type = "bezier", points = { { 0.00, 0.00 }, { 1.00, 1.00 } } })
hl.curve("ease_in", { type = "bezier", points = { { 0.55, 0.06 }, { 0.68, 0.19 } } })
hl.curve("ease_out", { type = "bezier", points = { { 0.21, 0.61 }, { 0.35, 1.00 } } })
hl.curve("ease_in_out", { type = "bezier", points = { { 0.65, 0.04 }, { 0.35, 1.00 } } })
hl.curve("ease_in_exp", { type = "bezier", points = { { 0.95, 0.05 }, { 0.80, 0.04 } } })
hl.curve("ease_out_exp", { type = "bezier", points = { { 0.19, 1.00 }, { 0.22, 1.00 } } })
hl.curve("ease_in_out_exp", { type = "bezier", points = { { 1.00, 0.00 }, { 0.00, 1.00 } } })
hl.animation({
    leaf = "windows",
    enabled = true,
    speed = 3,
    bezier = "ease_out_exp",
})
hl.animation({
    leaf = "windowsIn",
    enabled = true,
    speed = 3,
    bezier = "ease_out_exp",
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
    leaf = "layers",
    enabled = true,
    speed = 3,
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
    leaf = "fadeLayersOut",
    enabled = true,
    speed = 3,
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
    speed = 4,
    bezier = "ease_out_exp",
})

hl.config({
    general = {
        gaps_in = 3,
        gaps_out = 10,
        border_size = 1,
        col = {
            active_border = { colors = { "rgba(ffffff38)", "rgba(ffffff1a)" }, angle = 90 },
            inactive_border = "rgba(ffffff1a)",
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
            render_power = 1,
            color = "rgba(00000077)",
            color_inactive = "rgba(00000000)",
        },
        blur = {
            enabled = true,
            size = 8,
            passes = 3,
        },
    },
    dwindle = {
        preserve_split = true,
    },
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
    },
    gestures = {
        workspace_swipe_cancel_ratio = 0.2,
    },
})


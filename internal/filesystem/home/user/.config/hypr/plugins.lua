-- PLUGINS

-- Hyprexpo
if hl.plugin.hyprexpo ~= nil then
    hl.bind("SUPER + Tab", function()
        hl.plugin.hyprexpo.expo("toggle")
    end)

    hl.plugin.hyprexpo.gesture({
        fingers = 3,
        direction = "down",
        action = "expo",
    })

    hl.config({
        plugin = {
            hyprexpo = {
                gaps_in = 5,
                gaps_out = 5,
                bg_col = "rgb(000000)",
                tile_rounding = 10,
                border_width = 1,
                border_color_current = "rgb(000000)",
                border_color_focus = "rgb(000000)",
                border_color_hover = "rgb(000000)",
                drag_drop_proxy_color = "rgba(ffffff22)",
                drag_drop_proxy_active_color = "rgba(ffffff22)",
                drag_drop_proxy_border_color = "rgba(ffffff55)",
                drag_drop_proxy_border_width = 1,

                cancel_key = "escape",
                drag_drop_enable = 1,
                dynamic_grid = 1,
                show_workspace_names = false,
                label_enable = 0,
            },
        },
    })
end


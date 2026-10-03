local host = require("conf.host")

hl.config({
    dwindle = {
        preserve_split = true,
    },

    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
    },

    debug = {
        suppress_errors = true,
        disable_logs = false,
    },

    render = {
        direct_scanout = true,
        -- The laptop panel is sRGB-only; skipping the colour-management shader
        -- pass saves iGPU time on every frame. Keep it on the workstation.
        cm_enabled = not host.isLaptop,
    },

    input = {
        kb_layout = "pl",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",

        follow_mouse = 1,
        sensitivity = 0,

        touchpad = {},
    },
})

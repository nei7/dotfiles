----------------
---- MONITORS ----
----------------

hl.monitor({
    output = "",
    mode = "highrr",
    position = "auto",
    scale = 1,
})

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", "24")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")

hl.config({
    cursor = {
        no_hardware_cursors = false,
    },
})

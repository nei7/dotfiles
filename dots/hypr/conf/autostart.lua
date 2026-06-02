-- NixOS: strip ambient capabilities so Quickshell/Flatpak apps launch correctly
-- https://github.com/hyprwm/Hyprland/discussions/14844
local function execOnce(cmd)
    hl.exec_cmd("setpriv --ambient-caps -all " .. cmd)
end

hl.on("hyprland.start", function()
    execOnce("qs -c ii")
    execOnce("wl-paste --type text --watch cliphist store")
    execOnce("wl-paste --type image --watch cliphist store")
end)

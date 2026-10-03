-- NixOS: strip ambient capabilities so Quickshell/Flatpak apps launch correctly
-- https://github.com/hyprwm/Hyprland/discussions/14844
local function execOnce(cmd)
    hl.exec_cmd("setpriv --ambient-caps -all " .. cmd)
end

hl.on("hyprland.start", function()
    -- Replaces home-manager hyprland.systemd (cannot use with symlinked ~/.config/hypr).
    execOnce(
        "dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY HYPRLAND_INSTANCE_SIGNATURE XDG_CURRENT_DESKTOP"
    )
    -- Canonical path instead of `-c ii`: ~/.config/quickshell is a 3-hop symlink
    -- chain (HM store link) and every hop costs ~45 ms of startup. IPC/logs then
    -- need the same path: `qs ipc -p ~/dotfiles/dots/quickshell/ii ...`.
    execOnce("qs -p " .. os.getenv("HOME") .. "/dotfiles/dots/quickshell/ii")
    execOnce("hypridle")
    execOnce("wl-paste --type text --watch cliphist store")
    execOnce("wl-paste --type image --watch cliphist store")
end)

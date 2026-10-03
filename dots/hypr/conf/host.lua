-- Per-host switches for the otherwise shared Hyprland config.
-- /etc/hostname is written by NixOS from networking.hostName.
local M = {}

local function readHostname()
    local f = io.open("/etc/hostname", "r")
    if not f then
        return ""
    end
    local name = f:read("*l") or ""
    f:close()
    return (name:gsub("%s+$", ""))
end

M.hostname = readHostname()
-- HUAWEI MateBook 14: Vega 6 iGPU sharing 8 GB RAM, 2160x1440@60 panel.
M.isLaptop = M.hostname == "laptop"

return M

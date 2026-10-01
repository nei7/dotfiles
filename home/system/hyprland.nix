{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    # Whole-tree symlink at xdg.configFile."hypr" conflicts with HM-generated hyprland.conf.
    # Lua config uses hyprland.lua; import env via autostart.lua instead.
    systemd.enable = false;
  };

  # portalPackage = null → HM hyprland sets xdg.portal.enable = false (NixOS provides
  # xdg-desktop-portal-hyprland via programs.hyprland.portalPackage). Force enable
  # here for extra portals only.
  xdg.portal = {
    enable = lib.mkForce true;

    # HM's xdg.portal points the portal daemon at the user-profile portals dir
    # (NIX_XDG_DESKTOP_PORTAL_DIR), hiding system-level portals — XDPH must be
    # listed here or ScreenCast falls back to a broken impl. gnome/kde/wlr
    # portals can't work on Hyprland and only served as broken fallbacks.
    extraPortals = [
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];

    config = {
      common = {
        default = [
          "hyprland"
          "gtk"
        ];
      };
    };
  };

  xdg.configFile."hypr".source = config.lib.custom.mkLinkDotfiles "hypr";

  home.packages = with pkgs; [
    wl-clipboard
    libcap # setpriv — strips ambient caps for NixOS autostart (Quickshell/Flatpak)
    hypridle
  ];
}

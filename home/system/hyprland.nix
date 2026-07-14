{
  config,
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

    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
      kdePackages.xdg-desktop-portal-kde
    ];

    config = {
      common = {
        default = [ "hyprland" ];
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

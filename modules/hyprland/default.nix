{
  config,
  inputs,
  pkgs,
  ...
}:
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
  };

  xdg.configFile."hypr".source = config.lib.custom.mkLinkDotfiles "hypr";

  home.packages = with pkgs; [
    wl-clipboard
    libcap # setpriv — strips ambient caps for NixOS autostart (Quickshell/Flatpak)
  ];
}

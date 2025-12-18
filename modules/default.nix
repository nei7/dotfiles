{
  config,
  inputs,
  pkgs,
  ...
}:
{
  home.username = "nei";
  home.homeDirectory = "/home/nei";
  home.stateVersion = "25.05";

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = [ "brave.desktop" ];
      "image/png" = [ "org.kde.gwenview.desktop" ];
      "image/jpeg" = [ "org.kde.gwenview.desktop" ];
      "video/mp4" = [ "vlc.desktop" ];
      "text/html" = [ "brave.desktop" ];
      "x-scheme-handler/http" = [ "brave.desktop" ];
      "x-scheme-handler/https" = [ "brave.desktop" ];
    };
  };

  imports = [
    ./lib.nix

    ./packages
    ./zsh
    ./hyprland
    ./theme
    ./quickshell
    ./git
  ];
}

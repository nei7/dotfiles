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

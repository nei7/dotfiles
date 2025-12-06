{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./packages
    ./zsh
    ./hyprland
    ./theme
    ./quickshell
    ./git
    ./walker
  ];
}

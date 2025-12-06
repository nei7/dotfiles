{
  config,
  inputs,
  pkgs,
  ...
}:
{

  imports = [
    ./spotify.nix
    ./vscode.nix
    ./kitty.nix
  ];

  home.packages = with pkgs; [
    brave
    discord
    killall
    lxappearance
    pkgs.qtcreator
    protonvpn-gui

  ];
}

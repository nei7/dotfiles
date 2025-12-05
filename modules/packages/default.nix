{
  config,
  inputs,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    brave
    discord
    killall
    lxappearance
    pkgs.qt6.qttools
  ];
}

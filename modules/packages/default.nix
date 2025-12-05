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
  ];
}

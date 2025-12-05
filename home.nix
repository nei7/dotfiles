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
    ./modules/default.nix
  ];

}

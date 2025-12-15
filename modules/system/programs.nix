{
  config,
  pkgs,
  inputs,
  ...
}:

{
  programs = {
    nix-ld.enable = true;
    zsh.enable = true;

    hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
    };
  };
}

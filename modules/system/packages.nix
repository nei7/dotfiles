{
  config,
  pkgs,
  inputs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    kitty
    pkgs.nixfmt-rfc-style
  ];
}

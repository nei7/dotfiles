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
    nixfmt-rfc-style
    usbutils
    lsof
    zip
  ];
}

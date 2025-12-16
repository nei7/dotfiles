{
  config,
  inputs,
  pkgs,
  ...
}:
{
  xdg.configFile."hypr".source = config.lib.custom.mkLinkDotfiles "hypr";

  home.packages = with pkgs; [
    wl-clipboard
  ];
}

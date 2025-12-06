{
  config,
  inputs,
  pkgs,
  ...
}:
{
  xdg.configFile."hypr".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/hypr";

  home.packages = with pkgs; [
    wl-clipboard
  ];
}

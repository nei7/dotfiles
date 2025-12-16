{ config, ... }:

{
  config.lib.custom = {
    mkLinkDotfiles =
      path: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/dots/${path}";
  };
}

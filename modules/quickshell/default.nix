{
  config,
  inputs,
  pkgs,
  ...
}:
{

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
      kdePackages.xdg-desktop-portal-kde
    ];
  };

  xdg.configFile."quickshell".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/quickshell";

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    quickshell-wrapper

    cava
    ddcutil
    inetutils
    libnotify
    brightnessctl

    bc
    uutils-coreutils-noprefix
    cliphist
    cmake
    curlFull

    ripgrep
    jq
    xdg-user-dirs
    rsync
    yq-go

    fontconfig

    libsForQt5.qt5.qtwayland
    kdePackages.qtwayland
  ];
}

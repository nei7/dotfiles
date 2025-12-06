{
  config,
  inputs,
  pkgs,
  ...
}:
let

  quickshell-wrapper = pkgs.callPackage ./quickshell.nix {
    quickshell = inputs.quickshell;
  };
in
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
    wget
    ripgrep
    jq
    xdg-user-dirs
    rsync
    yq-go

    eza
    fontconfig
    kitty
    matugen
    starship
    nerd-fonts.jetbrains-mono
    material-symbols
    rubik
    twemoji-color-font

    libsForQt5.qt5.qtwayland
    kdePackages.qtwayland
  ];
}

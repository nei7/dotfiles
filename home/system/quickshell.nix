{
  config,
  pkgs,
  ...
}:
{
  xdg.configFile."quickshell".source = config.lib.custom.mkLinkDotfiles "quickshell";

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

    libsForQt5.qt5.qtwayland
    kdePackages.qtwayland
  ];
}

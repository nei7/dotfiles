{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
{

  imports = [
    ./vscode.nix
    ./kitty.nix
    ./direnv.nix
  ];

  home.packages = with pkgs; [

    # Cli tools
    killall
    fastfetch
    inputs.code-cursor-nix.packages.x86_64-linux.cursor
    unzip
    rar
    hyprpicker
    hyprshot
    ydotool
    wtype
    qt6.qtdeclarative

    # Apps
    kdePackages.kio-extras
    kdePackages.kservice
    lxappearance
    protonvpn-gui
    brave
    vlc
    kdePackages.dolphin
    kdePackages.gwenview
    pkgs.spotify
    (discord.override {
      withOpenASAR = true;
    })

    bitwarden-desktop

    btop
    pavucontrol

    postman
    docker-compose

  ];

  programs.chromium.extensions = [
    "nngceckbapebfimnlniiiahkandclblb"
  ];

  xdg.configFile."menus/applications.menu".source =
    "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

}

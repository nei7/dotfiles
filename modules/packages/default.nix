{
  config,
  inputs,
  pkgs,
  ...
}:
{

  imports = [
    ./vscode.nix
    ./kitty.nix
  ];

  home.packages = with pkgs; [

    # Cli tools
    killall
    fastfetch
    inputs.reStream.packages.${pkgs.system}.default
    unzip
    rar
    hyprpicker
    hyprshot
    ydotool
    wtype
    qt6.qtdeclarative

    # Apps
    lxappearance
    protonvpn-gui
    brave
    (discord.override {
      withOpenASAR = true;
    })
    vlc
    kdePackages.dolphin
    pkgs.spotify

    btop

  ];
}

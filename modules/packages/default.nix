{
  config,
  inputs,
  pkgs,
  ...
}:
{

  imports = [
    ./spotify.nix
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
    kdePackages.bluedevil
    kdePackages.plasma-nm
    kdePackages.dolphin

    btop

  ];
}

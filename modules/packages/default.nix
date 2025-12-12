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

    python3
    uv

    nodejs
    pnpm
    bun

    (texlive.withPackages (
      ps: with ps; [
        scheme-medium
        latexmk
      ]
    ))

    hyprpicker
    hyprshot

    ydotool
    wtype

    qt6.qtdeclarative

    btop
  ];
}

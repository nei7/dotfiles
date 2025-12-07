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
    (pkgs.python3.withPackages (python-pkgs: [
      python-pkgs.opencv4
      python-pkgs.numpy
    ]))

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

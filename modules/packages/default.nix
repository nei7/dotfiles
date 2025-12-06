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
    kdePackages.systemsettings
    (pkgs.python3.withPackages (python-pkgs: [
      python-pkgs.opencv4
      python-pkgs.numpy
    ]))
    nodejs
    pnpm

    bun
    uv

    (texlive.withPackages (
      ps: with ps; [
        scheme-medium
        latexmk
      ]
    ))

    hyprpicker
    hyprshot
    slurp
    swappy
    tesseract
    wf-recorder

    ydotool
    wtype
  ];
}

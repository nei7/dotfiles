{
  config,
  inputs,
  pkgs,
  ...
}:
let
  # Quickshell expects these display fonts; without them Qt falls back to Rubik.
  quickshellFonts = pkgs.runCommand "quickshell-extra-fonts" { } ''
    mkdir -p $out/share/fonts/truetype
    cp ${pkgs.fetchurl {
      url = "https://github.com/google/fonts/raw/main/ofl/gabarito/Gabarito%5Bwght%5D.ttf";
      name = "Gabarito-wght.ttf";
      hash = "sha256-hlDivXdH99dGGf167LywMJ5vN7eWQCTz+xWuSDO2fKU=";
    }} $out/share/fonts/truetype/'Gabarito[wght].ttf'
    cp ${pkgs.fetchurl {
      url = "https://github.com/google/fonts/raw/main/ofl/spacegrotesk/SpaceGrotesk%5Bwght%5D.ttf";
      name = "SpaceGrotesk-wght.ttf";
      hash = "sha256-rK1t4fyTQ29cDx9BN3Ue8E8a6jBj5wNlNZcP/PvXn3I=";
    }} $out/share/fonts/truetype/'SpaceGrotesk[wght].ttf'
  '';
in
{
  home.packages = with pkgs; [
    adw-gtk3
    kdePackages.breeze
    kdePackages.breeze-icons
    darkly
    papirus-icon-theme
    bibata-cursors

    rubik
    roboto-flex
    readexpro
    quickshellFonts
    nerd-fonts.jetbrains-mono
    material-symbols
    twitter-color-emoji
    fontconfig
  ];

  gtk = {
    enable = true;

    font = {
      name = "Rubik";
      package = pkgs.rubik;
      size = 12;
    };

    theme = {
      name = "Adwaita";
      package = pkgs.adw-gtk3;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
  };

  qt = {
    enable = true;
    platformTheme = {
      name = "qtct";
    };

  };

  xdg.configFile."kdeglobals".text = ''
    [Icons]
    Theme=Papirus-Dark
  '';

  xdg.configFile."qt5ct".source = config.lib.custom.mkLinkDotfiles "qt5ct";

  xdg.configFile."btop".source = config.lib.custom.mkLinkDotfiles "btop";

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      sansSerif = [ "Rubik" ];

      monospace = [ "JetBrainsMono Nerd Font" ];

      emoji = [ "Twitter Color Emoji" ];
    };
  };
}

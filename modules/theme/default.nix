{
  config,
  inputs,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    adw-gtk3
    kdePackages.breeze
    kdePackages.breeze-icons
    darkly
    darkly-qt5
    papirus-icon-theme
    bibata-cursors
  ];

  gtk = {
    enable = true;

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
    platformTheme = "qtct";
    style = {
      name = "Darkly";
      package = pkgs.darkly-qt5;

    };
  };

  xdg.configFile."kdeglobals".text = ''
    [Icons]
    Theme=Papirus-Dark
  '';

}

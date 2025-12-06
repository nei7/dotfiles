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
      name = "Breeze";
      package = pkgs.kdePackages.breeze;
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

  qt = {
    enable = true;
    platformTheme = "qtct";
    style.name = "kvantum";
  };

}

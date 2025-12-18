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
    ./direnv.nix
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

    btop
  ];

  xdg.configFile."menus/applications.menu".source =
    "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

}

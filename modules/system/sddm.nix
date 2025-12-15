{
  config,
  pkgs,
  inputs,
  ...
}:

let
  avatarUrl = ./nei.face.icon;
  # myWallpaperPkg = pkgs.runCommand "mojatapeta.png" { } ''
  #   cp ${./wallpaper.png} $out
  # '';

  sddm-theme = inputs.silentSDDM.packages.${pkgs.system}.default.override {
    theme = "catppuccin-latte";

    # extraBackgrounds = [ myWallpaperPkg ];

    theme-overrides = {
      "LockScreen" = {
        background-color = "#141313";
      };

      "LoginScreen" = {
        # background = "${myWallpaperPkg.name}";
        background-color = "#141313";
      };

      "LockScreen.Message" = {
        color = "#e6e1e1";
      };

      "LoginScreen.LoginArea.Avatar" = {
        active-border-color = "#cbc4cb";
        inactive-border-color = "#cbc4cb";
      };

      "LoginScreen.LoginArea.Username" = {
        color = "#e6e1e1";
      };

      "LoginScreen.LoginArea.PasswordInput" = {
        content-color = "#e6e1e1";
        background-color = "#2b2a2a";
        border-color = "#cbc4cb";
      };

      "LoginScreen.LoginArea.LoginButton" = {
        background-color = "#2b2a2a";
        active-background-color = " #cbc4cb";
        content-color = " #cbc4cb";
        active-content-color = "#322f34";
        border-color = "#cbc4cb";
      };
      "LoginScreen.LoginArea.WarningMessage" = {
        normal-color = "#e6e1e1";
        warning-color = "#AF535D";
        error-color = "#ffb4ab";
      };

      "LoginScreen.MenuArea.Popups" = {
        background-color = "#201f20";
        active-option-background-color = "#49464a";
        content-color = "#e6e1e1";
        active-content-color = "#cbc4cb";
      };

      "LockScreen.Clock" = {
        color = "#e6e1e1";
      };

      "LockScreen.Date" = {
        color = "#cbc5ca";
      };

      "LoginScreen.MenuArea.Session" = {
        background-color = "#cbc4cb";
        content-color = "#e6e1e1";
        active-content-color = "#322f34";
      };

      "LoginScreen.MenuArea.Layout" = {
        content-color = "#e6e1e1";
        active-content-color = "#322f34";
        background-color = "#cbc4cb";
      };

      "LoginScreen.MenuArea.Keyboard" = {
        background-color = "#cbc4cb";
        content-color = "#e6e1e1";
        active-content-color = "#322f34";
      };

      "LoginScreen.MenuArea.Power" = {
        content-color = "#e6e1e1";
        active-content-color = "#322f34";
        background-color = "#cbc4cb";
      };

      "LoginScreen.VirtualKeyboard" = {
        key-content-color = "#e6e1e1";
        key-color = "#201f20";
        background-color = "#201f20";
        key-active-background-color = "#49464a";
        selection-background-color = "#e6e1e1";
        selection-content-color = "#141313";
        primary-color = "#cbc4cb";
        border-color = "#cbc4cb";
      };

      "Tooltips" = {
        content-color = "#e6e1e1";
        background-color = "#201f20";
      };
    };
  };

in
{

  services.displayManager.sddm = {
    enable = true;
    package = pkgs.kdePackages.sddm;
    theme = "silent";

    wayland.enable = true;
    extraPackages = [
      pkgs.kdePackages.qtsvg
      pkgs.kdePackages.qtmultimedia
      pkgs.kdePackages.qtvirtualkeyboard
    ];

    settings = {
      Theme = {
        FacesDir = "/etc/sddm/faces";
      };
    };
  };

  environment.etc."sddm/faces/nei.face.icon".source = avatarUrl;

  environment.systemPackages = [
    sddm-theme
    sddm-theme.test
  ];
}

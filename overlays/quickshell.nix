{ inputs }:

final: prev:
let
  system = prev.system;

  qs = inputs.quickshell.packages.${system}.default;
in
{
  quickshell-wrapper = prev.stdenv.mkDerivation {
    pname = "quickshell-wrapper";
    inherit (qs) version;

    meta = with prev.lib; {
      description = "Quickshell bundled with Qt deps";
      license = licenses.gpl3Only;
    };

    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;

    nativeBuildInputs = [
      prev.makeWrapper
      prev.qt6.wrapQtAppsHook
    ];

    buildInputs = with prev; [
      qs

      qt6.qtbase
      qt6.qtdeclarative
      qt6.qt5compat
      qt6.qtimageformats
      qt6.qtmultimedia
      qt6.qtpositioning
      qt6.qtquicktimeline
      qt6.qtsensors
      qt6.qtsvg
      qt6.qttools
      qt6.qttranslations
      qt6.qtvirtualkeyboard
      qt6.qtwayland

      kdePackages.kirigami
      kdePackages.kdialog
      kdePackages.syntax-highlighting
      kdePackages.qtwayland

      gsettings-desktop-schemas
    ];

    installPhase = ''
      mkdir -p $out/bin

      # Używamy makeWrapper do stworzenia wrappera
      makeWrapper ${qs}/bin/qs $out/bin/qs \
        --prefix XDG_DATA_DIRS : ${prev.gsettings-desktop-schemas}/share/gsettings-schemas/${prev.gsettings-desktop-schemas.name}
    '';
  };
}

{ inputs }:

final: prev:
let
  qs = inputs.quickshell.packages.${prev.stdenv.hostPlatform.system}.default;
in
{
  # Upstream's wrapper already carries qtbase, qtdeclarative, qtsvg and qtwayland;
  # add only the extra QML modules the ii config imports (Qt5Compat.GraphicalEffects)
  # and image-format plugins (webp etc. for icons/cover art). Keeps the import and
  # plugin search paths short and ships org.quickshell.desktop for the portal.
  quickshell-wrapper = qs.withModules [
    prev.qt6.qt5compat
    prev.qt6.qtimageformats
  ];
}

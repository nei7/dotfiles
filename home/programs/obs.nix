{
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  nvidia = lib.elem "nvidia" (osConfig.services.xserver.videoDrivers or [ ]);
in
{
  programs.obs-studio = {
    enable = true;

    # - LD_LIBRARY_PATH: obs-nvenc-test lacks /run/opengl-driver/lib in its
    #   RUNPATH, so NVENC probing fails without it (nixpkgs packaging gap).
    # - QT_QPA_PLATFORM=xcb (NVIDIA only): explicit-sync protocol error kills
    #   OBS's Wayland connection ("Missing acquire timeline"); running via
    #   XWayland avoids it. PipeWire screen capture is unaffected.
    package = pkgs.symlinkJoin {
      name = "obs-studio-wrapped";
      paths = [ pkgs.obs-studio ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/obs \
          --prefix LD_LIBRARY_PATH : /run/opengl-driver/lib \
          ${lib.optionalString nvidia "--set QT_QPA_PLATFORM xcb"}
      '';
    };

    plugins = with pkgs.obs-studio-plugins; [
      # Desktop/app audio capture via PipeWire
      obs-pipewire-audio-capture
      # VAAPI hardware encoding (AMD/Intel)
      obs-vaapi
    ];
  };
}

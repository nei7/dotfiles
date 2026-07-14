final: prev: {
  spotify-adblock = prev.rustPlatform.buildRustPackage {
    pname = "spotify-adblock";
    version = "1.1.0";

    src = prev.fetchFromGitHub {
      owner = "abba23";
      repo = "spotify-adblock";
      rev = "v1.1.0";
      fetchSubmodules = false;
      hash = "sha256-3X7vScKmnb65wJ4xWAT2AeyAMPTGzKZCFA549zm9gLc=";
    };

    cargoHash = "sha256-gxGetdqaoJa/ZF1VnW6UXJyJfLBGZxZnyKpT/Qk/8Og=";

    # v1.1.0 loads config from XDG or /etc; point the fallback at the Nix store path.
    patchPhase = ''
      substituteInPlace src/config.rs \
        --replace 'const GLOBAL_CONFIG_DIR: &str = "/etc";' "const GLOBAL_CONFIG_DIR: &str = \"$out/etc\";"
    '';

    installPhase = ''
      mkdir -p $out/etc/spotify-adblock
      install -D --mode=644 config.toml $out/etc/spotify-adblock/config.toml
      mkdir -p $out/lib
      install -D --mode=644 --strip target/*/release/libspotifyadblock.so $out/lib/libspotifyadblock.so
    '';
  };

  spotify = prev.symlinkJoin {
    name = "spotify-adblocked";
    paths = [ prev.spotify ];
    buildInputs = [ prev.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/spotify \
        --run '
          cache="$HOME/.cache/spotify"
          socket="$cache/SingletonSocket"
          if [ -L "$socket" ]; then
            target=$(readlink "$socket")
            if [ ! -S "$target" ]; then
              rm -f "$cache/SingletonLock" "$cache/SingletonSocket" "$cache/SingletonCookie"
            fi
          fi
        ' \
        --set NIXOS_OZONE_WL 0 \
        --set LD_PRELOAD "${final.spotify-adblock}/lib/libspotifyadblock.so"
    '';
  };
}

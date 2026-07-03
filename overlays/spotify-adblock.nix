final: prev: {
  spotify-adblock = prev.rustPlatform.buildRustPackage {
    pname = "spotify-adblock";
    version = "0-unstable-2025-05-20";

    src = prev.fetchFromGitHub {
      owner = "abba23";
      repo = "spotify-adblock";
      rev = "9aeadd3cfd4d50212059720c09f662f149942fec";
      fetchSubmodules = false;
      hash = "sha256-3X7vScKmnb65wJ4xWAT2AeyAMPTGzKZCFA549zm9gLc=";
    };

    cargoHash = "sha256-gxGetdqaoJa/ZF1VnW6UXJyJfLBGZxZnyKpT/Qk/8Og=";

    patchPhase = ''
      substituteInPlace src/lib.rs \
        --replace 'config.toml' $out/etc/spotify-adblock/config.toml
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
        --set LD_PRELOAD "${final.spotify-adblock}/lib/libspotifyadblock.so"
    '';
  };
}

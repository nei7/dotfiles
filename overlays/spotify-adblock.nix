# overlays/spotify-adblock.nix
final: prev: {
  spotify-adblock = prev.rustPlatform.buildRustPackage {
    pname = "spotify-adblock";
    version = "lastcommit at 2025-05-20";

    src = prev.fetchFromGitHub {
      owner = "abba23";
      repo = "spotify-adblock";
      rev = "refs/heads/main";
      fetchSubmodules = false;
      hash = "sha256-nwiX2wCZBKRTNPhmrurWQWISQdxgomdNwcIKG2kSQsE=";
    };

    cargoHash = "sha256-oGpe+kBf6kBboyx/YfbQBt1vvjtXd1n2pOH6FNcbF8M=";

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

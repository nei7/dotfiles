{
  config,
  inputs,
  pkgs,
  ...
}:
let
  spotify-adblock = pkgs.rustPlatform.buildRustPackage {
    pname = "spotify-adblock";
    version = "lastcommit at 2025-05-20";
    src = pkgs.fetchFromGitHub {
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

    buildPhase = ''
      make
    '';

    installPhase = ''
      mkdir -p $out/etc/spotify-adblock
      install -D --mode=644 config.toml $out/etc/spotify-adblock
      mkdir -p $out/lib
      install -D --mode=644 --strip target/release/libspotifyadblock.so $out/lib
    '';
  };

in
{
  home.packages = [
    pkgs.spotify
    spotify-adblock
  ];

  xdg.desktopEntries.spotify-adblocked = {
    name = "Spotify (Adblock)";
    exec = "env LD_PRELOAD=${spotify-adblock}/lib/libspotifyadblock.so ${pkgs.spotify}/bin/spotify %U";
    terminal = false;
    icon = "spotify";

    categories = [
      "Audio"
      "Music"
      "Player"
      "AudioVideo"
    ];
    mimeType = [ "x-scheme-handler/spotify" ];
  };

}

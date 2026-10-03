final: prev:
let
  spotifyAdblockOverlay = import ./spotify-adblock.nix final prev;
  obsidianOverlay = import ./obsidian.nix final prev;
in
spotifyAdblockOverlay // obsidianOverlay

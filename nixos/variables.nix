{ lib, ... }:

{
  # Per-host variables live in hosts/<host>/variables.nix and are read by the
  # modules below via `config.var.*`.
  options.var = lib.mkOption {
    type = lib.types.attrs;
    default = { };
  };
}

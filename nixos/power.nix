{
  config,
  lib,
  ...
}:

let
  isLaptop = config.var.isLaptop or false;
in
{
  services.upower.enable = true;

  # Laptop-only: TLP power saving and zram (helps the 8GB MateBook).
  services.tlp.enable = lib.mkIf isLaptop true;
  zramSwap.enable = lib.mkIf isLaptop true;
}

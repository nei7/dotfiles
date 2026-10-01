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

  services.logind.settings.Login = {
    HandlePowerKey = "suspend";
    HandleSuspendKey = "suspend";
  } // lib.optionalAttrs isLaptop {
    HandleLidSwitch = "suspend";
  };

  boot.kernelParams = [ "mem_sleep_default=deep" ];

  # Laptop-only: TLP power saving and zram (helps the 8GB MateBook).
  services.tlp.enable = lib.mkIf isLaptop true;
  zramSwap.enable = lib.mkIf isLaptop true;
}

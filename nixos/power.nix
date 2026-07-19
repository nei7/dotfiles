{
  config,
  lib,
  pkgs,
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

  # Wireless dongles / RGB keyboards assert wake right after S3, so sleep
  # appears broken. Case power button still wakes the machine.
  services.udev.extraRules = ''
    ACTION=="add|change", SUBSYSTEM=="usb", ATTR{idVendor}=="3299", ATTR{idProduct}=="006c", ATTR{power/wakeup}="disabled"
    ACTION=="add|change", SUBSYSTEM=="usb", ATTR{idVendor}=="1038", ATTR{idProduct}=="1618", ATTR{power/wakeup}="disabled"
    ACTION=="add", SUBSYSTEM=="usb", DRIVER=="usbhid", ATTR{power/wakeup}="disabled"
  '';

  # XHCI controllers on this AMD board also bounce out of S3 immediately.
  systemd.services.disable-xhci-wakeup = {
    description = "Disable XHCI ACPI wakeup (fixes instant resume)";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "disable-xhci-wakeup" ''
        for dev in XHC0 XHC1 XHC2 XH00; do
          if grep -q "^$dev.*enabled" /proc/acpi/wakeup; then
            echo "$dev" > /proc/acpi/wakeup
          fi
        done
      '';
    };
  };

  # Laptop-only: TLP power saving and zram (helps the 8GB MateBook).
  services.tlp.enable = lib.mkIf isLaptop true;
  zramSwap.enable = lib.mkIf isLaptop true;
}

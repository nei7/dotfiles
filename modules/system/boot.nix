{
  config,
  pkgs,
  inputs,
  ...
}:

{

  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;

  boot.loader = {
    systemd-boot.enable = false;
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      device = "nodev";
      fontSize = 16;
      efiSupport = true;
      useOSProber = true;

      configurationLimit = 5;
    };
  };

  boot.loader.timeout = 5;

  boot.plymouth.enable = true;

  boot.kernelParams = [
    "quiet"
    "splash"
    "boot.consoleLogLevel=0"
    "systemd.show_status=false"
    "udev.log_level=3"
    "vt.global_cursor_default=0"
    "boot.shell_on_fail"
    "loglevel=3"
    "rd.systemd.show_status=false"
    "rd.udev.log_level=3"
    "udev.log_priority=3"
  ];

}

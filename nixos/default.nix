{ config, ... }:

{
  imports = [
    ./variables.nix

    ./boot.nix
    ./audio.nix
    ./locale.nix
    ./nix.nix
    ./packages.nix
    ./programs.nix
    ./sddm.nix
    ./users.nix
    ./android.nix
    ./power.nix
  ];

  networking.hostName = config.var.hostname;

  environment.variables = {
    EDITOR = "vim";
  };
  hardware.bluetooth.enable = true;
  networking.networkmanager.enable = true;

  networking.firewall.allowedTCPPorts = [
    3000
  ];
  networking.nameservers = [
    "1.1.1.1"
    "9.9.9.9"
  ];

  system.stateVersion = "25.05";
}

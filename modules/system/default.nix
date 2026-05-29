{ ... }:

{

  imports = [
    ./boot.nix
    ./audio.nix
    ./locale.nix
    ./nix-settings.nix
    ./packages.nix
    ./programs.nix
    ./sddm.nix
    ./user.nix
    ./android.nix
  ];

  environment.variables = {
    EDITOR = "vim";
  };

  services.upower.enable = true;
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

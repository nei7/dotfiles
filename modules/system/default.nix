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

  services.upower.enable = true;
  networking.networkmanager.enable = true;

  system.stateVersion = "25.05";
}

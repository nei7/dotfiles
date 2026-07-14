{
  config,
  inputs,
  ...
}:

{
  imports = [
    ../../nixos

    ../../nixos/gpu/nvidia.nix
    ../../nixos/docker.nix

    ./hardware-configuration.nix
    ./variables.nix
  ];

  # SSH server so the laptop can reach this machine as a remote builder.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };

  # Accept remote builds offloaded from the laptop (see nixos/distributed-build.nix).
  nix.settings.trusted-users = [ "nei" ];

  boot.resumeDevice = "/dev/disk/by-uuid/1f8d3598-1b06-4cca-a9c1-6623dd533c12";

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs; };
    users.${config.var.username} = import ./home.nix;
    backupFileExtension = "backup";
  };
}

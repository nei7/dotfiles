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

  # Accept remote builds offloaded from the laptop (see nixos/distributed-build.nix).
  nix.settings.trusted-users = [ "nei" ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs; };
    users.${config.var.username} = import ./home.nix;
    backupFileExtension = "backup";
  };
}

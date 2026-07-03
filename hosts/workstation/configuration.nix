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

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs; };
    users.${config.var.username} = import ./home.nix;
    backupFileExtension = "backup";
  };
}

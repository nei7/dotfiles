{
  config,
  inputs,
  ...
}:

{
  imports = [
    ../../nixos

    ../../nixos/gpu/amd.nix

    # Offload heavy builds to the workstation when on the same network.
    ../../nixos/distributed-build.nix

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

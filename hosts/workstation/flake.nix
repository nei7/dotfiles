{
  inputs,
  nixpkgs,
  system,
  ...
}:

nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = { inherit inputs; };

  modules = [
    {
      nixpkgs.overlays = [
        (import ../../overlays)
        (import ../../overlays/quickshell.nix { inherit inputs; })
      ];
    }

    # AMD Ryzen 7 9700X workstation.
    inputs.nixos-hardware.nixosModules.common-cpu-amd

    inputs.home-manager.nixosModules.home-manager

    ./configuration.nix
  ];
}

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

    # HUAWEI MateBook 14 (Ryzen 5 4600H) — generic AMD laptop profiles.
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd

    inputs.home-manager.nixosModules.home-manager

    ./configuration.nix
  ];
}

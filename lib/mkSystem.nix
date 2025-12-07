{ self, ... }@inputs:
name: system:
inputs.nixpkgs.lib.nixosSystem ({
  inherit system;
  specialArgs = { inherit inputs self; };
  modules = [
    "${self}/hosts/${name}/user.nix"
    inputs.home-manager.nixosModule
  ];
})

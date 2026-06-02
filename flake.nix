{
  description = "Hyprland on Nixos";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      # Includes Hyprland Lua dispatch support (hl.dsp.* via IPC, Hyprland.usingLua).
      url = "github:quickshell-mirror/quickshell/b66495fcc5022681b56b61f928c7acbe910e722c";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    silentSDDM = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    code-cursor-nix.url = "github:jacopone/code-cursor-nix";

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;

      # https://github.com/sioodmy/dotfiles/blob/main/flake.nix
      mkSystem =
        pkgs: system: hostname:
        nixpkgs.lib.nixosSystem {

          system = system;
          specialArgs = { inherit inputs; };
          modules = [

            (
              { pkgs, ... }:
              {
                nixpkgs.overlays = [
                  (import ./overlays)
                  (import ./overlays/quickshell.nix { inherit inputs; })
                ];
              }
            )
            { networking.hostName = "${hostname}"; }

            ./modules/system

            (./. + "/hosts/${hostname}/hardware-configuration.nix")
            (./. + "/hosts/${hostname}/system.nix")

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useUserPackages = true;
                useGlobalPkgs = true;
                extraSpecialArgs = { inherit inputs; };
                users.nei = (./. + "/hosts/${hostname}/user.nix");
                backupFileExtension = "backup";
              };
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        desktop = mkSystem inputs.nixpkgs "x86_64-linux" "desktop";
        laptop = mkSystem inputs.nixpkgs "x86-64-linux" "laptop";
      };

    };
}

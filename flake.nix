{
  description = "Hyprland on NixOS";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      # Tracks master. Hyprland Lua dispatch support (hl.dsp.* via IPC,
      # Hyprland.usingLua) landed on 2026-06-01 and is in every release since v0.3.1.
      url = "github:quickshell-mirror/quickshell";
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

    claude-code.url = "github:sadjow/claude-code-nix";

  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      ...
    }:
    let
      system = "x86_64-linux";

      # Shared args passed to every per-host flake.nix (nixy-style).
      args = {
        inherit inputs nixpkgs system;
        pkgs = nixpkgs.legacyPackages.${system};
      };
    in
    {
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;

      nixosConfigurations = {
        laptop = import ./hosts/laptop/flake.nix args;
        workstation = import ./hosts/workstation/flake.nix args;
      };
    };
}

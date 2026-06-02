{
  config,
  pkgs,
  inputs,
  ...
}:

{
  programs = {
    nix-ld.enable = true;
    zsh.enable = true;

    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      xwayland.enable = true;
      withUWSM = true;
    };
  };

  programs.ssh.extraConfig = ''
    Host remarkable
      HostName 192.168.0.150
      User root
      PubkeyAcceptedKeyTypes +ssh-rsa
      HostKeyAlgorithms +ssh-rsa
  '';
}

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

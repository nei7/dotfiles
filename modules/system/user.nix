{
  config,
  pkgs,
  inputs,
  ...
}:

{
  users.users.nei = {
    isNormalUser = true;
    description = "nei";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [ ];
    shell = pkgs.zsh;
  };

}

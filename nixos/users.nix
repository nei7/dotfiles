{
  config,
  pkgs,
  inputs,
  ...
}:

{
  users.users.${config.var.username} = {
    isNormalUser = true;
    description = config.var.username;
    extraGroups = [
      "networkmanager"
      "wheel"
      "adbusers"
    ];
    packages = with pkgs; [ ];
    shell = pkgs.zsh;
  };

}

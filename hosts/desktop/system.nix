{
  config,
  pkgs,
  inputs,
  ...
}:
{
  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = [ "nei" ];
}

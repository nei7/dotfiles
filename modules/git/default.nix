{
  config,
  inputs,
  pkgs,
  ...
}:
{
  programs.git = {
    enable = true;
    userName = "nei7";
    userEmail = "franciszek.szarek2@gmail.com";
    extraConfig = {
      init = {
        defaultBranch = "master";
      };
    };
  };
}

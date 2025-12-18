{
  config,
  inputs,
  pkgs,
  ...
}:
{
  programs.git = {
    enable = true;

    settings = {
      user = {
        email = "franciszek.szarek2@gmail.com";
        name = "nei7";
      };
      init = {
        defaultBranch = "master";
      };
    };

  };
}

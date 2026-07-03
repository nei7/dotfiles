{
  osConfig,
  ...
}:
{
  programs.git = {
    enable = true;

    settings = {
      user = {
        email = osConfig.var.git.email;
        name = osConfig.var.git.name;
      };
      init = {
        defaultBranch = "master";
      };
    };

  };
}

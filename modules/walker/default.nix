{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.walker.homeManagerModules.default
  ];

  xdg.configFile."walker".source = ../../.config/walker;
  programs.walker = {
    enable = true;
    runAsService = true;
  };
}

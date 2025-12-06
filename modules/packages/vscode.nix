{
  config,
  inputs,
  pkgs,
  ...
}:
{
  programs.vscode = {
    enable = true;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
        dotjoshjohnson.xml
        pkief.material-icon-theme
      ];
      userSettings = {
        "editor.formatOnSave" = true;
        "workbench.colorTheme" = "Dark modern";
        "workbench.iconTheme" = "material-icon-theme";
      };
    };
  };
}

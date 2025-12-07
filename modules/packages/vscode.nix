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

        ms-python.python
        ms-python.debugpy

        vue.volar
        bradlc.vscode-tailwindcss
        esbenp.prettier-vscode
        dbaeumer.vscode-eslint

        ms-azuretools.vscode-docker

        james-yu.latex-workshop

        wakatime.vscode-wakatime
      ];
      userSettings = {
        "editor.formatOnSave" = true;
        "workbench.colorTheme" = "Dark modern";
        "workbench.iconTheme" = "material-icon-theme";
      };
    };
  };
}

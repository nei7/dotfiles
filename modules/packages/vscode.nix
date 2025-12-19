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
        mkhl.direnv

      ];
      userSettings = {
        "editor.formatOnSave" = true;
        "workbench.colorTheme" = "Dark Modern";
        "workbench.iconTheme" = "material-icon-theme";
        "[vue]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[javascript]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[typescript]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "prettier.requireConfig" = true;

        "editor.codeActionsOnSave" = {
          "source.fixAll.eslint" = true;
        };
      };
    };
  };
}

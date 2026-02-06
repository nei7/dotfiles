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
        "workbench.iconTheme" = "material-icon-theme";

        "[json]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[vue]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[javascript]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[typescript]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };

        "editor.codeActionsOnSave" = {
          "source.fixAll.eslint" = "explicit";
        };

        "eslint.useFlatConfig" = true;
      };
    };
  };
}

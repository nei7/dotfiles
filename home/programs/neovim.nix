{
  config,
  pkgs,
  ...
}:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # NvChad manages plugins itself (lazy.nvim). LSPs and formatters come from
    # nixpkgs instead of Mason, because Mason's prebuilt binaries don't run on NixOS.
    extraPackages = with pkgs; [
      # treesitter parsers / telescope
      gcc
      gnumake
      tree-sitter
      nodejs
      unzip
      ripgrep
      fd
      wl-clipboard

      # LSP
      lua-language-server
      nil
      vscode-langservers-extracted # html, css, json, eslint
      typescript-language-server
      pyright
      bash-language-server
      clang-tools # clangd, clang-format
      kdePackages.qtdeclarative # qmlls

      # formatters
      stylua
      nixfmt
      prettierd
      ruff
      shfmt
    ];
  };

  # Out-of-store symlink so lazy-lock.json and :Lazy updates stay writable.
  xdg.configFile."nvim".source = config.lib.custom.mkLinkDotfiles "nvim";
}

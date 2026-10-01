{
  config,
  inputs,
  pkgs,
  ...
}:
{

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs # Opcjonalnie: do specyficznego przechwytywania w Hyprland/Sway
      obs-vkcapture # Przydatne do bezpośredniego przechwytywania gier Vulkan/OpenGL z pominięciem kompozytora
    ];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
}

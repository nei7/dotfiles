{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ../modules/sddm
  ];

  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    fontSize = 16;
    efiSupport = true;
    useOSProber = true;
    timeout = 5;
    configurationLimit = 5;
  };
  boot.plymouth.enable = true;

  services.upower.enable = true;

  networking.networkmanager.enable = true;

  # Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  # Locale
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };
  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "pl2";

  # User
  programs.zsh.enable = true;
  users.users.nei = {
    isNormalUser = true;
    description = "nei";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [ ];
    shell = pkgs.zsh;
  };

  # Environment
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    kitty
    pkgs.nixfmt-rfc-style
  ];

  programs.nix-ld.enable = true;

  # GC
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "25.05";

}

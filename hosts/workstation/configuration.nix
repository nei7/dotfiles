{
  config,
  inputs,
  ...
}:

{
  imports = [
    ../../nixos

    ../../nixos/gpu/nvidia.nix
    ../../nixos/docker.nix

    ./hardware-configuration.nix
    ./variables.nix
  ];

  # SSH server so the laptop can reach this machine as a remote builder.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };

  # Accept remote builds offloaded from the laptop (see nixos/distributed-build.nix).
  nix.settings.trusted-users = [ "nei" ];

  boot.resumeDevice = "/dev/disk/by-uuid/1f8d3598-1b06-4cca-a9c1-6623dd533c12";

  # Instant resume from S3 on this B850 board: the chipset's PCIe WAKE# line
  # (pin 3 of the SoC GPIO controller, AMDI0030:00) pulses ~1 s after entering
  # S3. Diagnosed via /sys/power/pm_wakeup_irq = 7 (pinctrl_amd) and
  # "GPIO 3 is active" in dmesg with pm_debug_messages on; no ACPI GPE fired,
  # so toggling /proc/acpi/wakeup entries never helped. Nothing behind the
  # chipset needs to wake the machine (its USB controller loses power in S3
  # anyway), so ignore that pin as a wake source. The power button (fixed ACPI
  # event) and the CPU-attached USB controllers are unaffected.
  boot.kernelParams = [ "gpiolib_acpi.ignore_wake=AMDI0030:00@3" ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs; };
    users.${config.var.username} = import ./home.nix;
    backupFileExtension = "backup";
  };
}

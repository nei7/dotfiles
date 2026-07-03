{
  ...
}:

# Client-side config: offload heavy builds (e.g. quickshell/Qt) from the laptop
# to the workstation over SSH. When the workstation is unreachable (laptop off
# the LAN), nix drops the builder after ConnectTimeout and builds locally.
{
  nix.distributedBuilds = true;

  # Let the remote builder pull dependencies from binary caches itself instead
  # of the laptop uploading the full closure.
  nix.settings.builders-use-substitutes = true;

  nix.buildMachines = [
    {
      hostName = "workstation-builder";
      sshUser = "nei";
      # nixos-rebuild runs as root, so this must be root's key on the laptop,
      # and its public part must be in nei@workstation:~/.ssh/authorized_keys.
      sshKey = "/root/.ssh/id_ed25519";
      systems = [ "x86_64-linux" ];
      protocol = "ssh-ng";
      maxJobs = 8;
      speedFactor = 2;
      supportedFeatures = [
        "nixos-test"
        "benchmark"
        "big-parallel"
        "kvm"
      ];
    }
  ];

  # Alias + short timeout so an offline workstation fails fast to local build.
  programs.ssh.extraConfig = ''
    Host workstation-builder
      HostName 192.168.0.60
      User nei
      IdentityFile /root/.ssh/id_ed25519
      ConnectTimeout 5
      StrictHostKeyChecking accept-new
  '';
}

{
  config,
  pkgs,
  ...
}:

{
  # KVM/QEMU virtual machines managed by libvirt; GUI via virt-manager
  # (or `virsh` on the command line). Connection URI: qemu:///system.
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm; # x86_64 guests only, smaller closure than pkgs.qemu
      swtpm.enable = true; # emulated TPM for guests that want one (Windows 11)
    };
  };

  # USB passthrough to guests from the virt-manager console (SPICE).
  virtualisation.spiceUSBRedirection.enable = true;

  programs.virt-manager.enable = true;

  users.extraGroups.libvirtd.members = [ config.var.username ];

  # Guests on the default NAT network (virbr0, 192.168.122.0/24) get DHCP/DNS
  # from libvirt's dnsmasq; keep the NixOS firewall out of the way on that bridge.
  networking.firewall.trustedInterfaces = [ "virbr0" ];

  # libvirt ships the "default" NAT network definition but does not start it;
  # mark it autostart once so new VMs have networking without a manual `virsh net-start`.
  systemd.services.libvirtd-default-network = {
    description = "Autostart the libvirt 'default' NAT network";
    wantedBy = [ "multi-user.target" ];
    after = [ "libvirtd.service" ];
    requires = [ "libvirtd.service" ];
    serviceConfig.Type = "oneshot";
    script = ''
      virsh=${config.virtualisation.libvirtd.package}/bin/virsh
      $virsh net-autostart default >/dev/null 2>&1 || true
      $virsh net-info default | grep -q 'Active:.*yes' || $virsh net-start default || true
    '';
  };
}

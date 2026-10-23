{ ... }:

{
  # Connect virt-manager to the system libvirt daemon automatically
  # (otherwise the first start shows an empty window and asks for a connection).
  dconf.settings."org/virt-manager/virt-manager/connections" = {
    autoconnect = [ "qemu:///system" ];
    uris = [ "qemu:///system" ];
  };
}

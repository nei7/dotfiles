{
  pkgs,
  ...
}:

{
  boot.kernelParams = [
    "amdgpu.dcdebugmask=0x10"
  ];
  boot.kernelModules = [ "amdgpu" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = with pkgs; [
      rocmPackages.clr

      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };
}

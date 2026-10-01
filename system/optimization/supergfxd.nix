{ config, pkgs, ... }:

{
  services.supergfxd.enable = true;

  environment.systemPackages = with pkgs; [
    supergfxctl
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = with pkgs; [
      mesa.opencl
      intel-media-driver
      intel-vaapi-driver
      libvdpau-va-gl
    ];
  };
}

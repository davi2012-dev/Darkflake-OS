{ config, pkgs, lib, ... }:

{
  virtualisation.xen = {
    enable = true;
    dom0 = {
      enable = true;
      cores = 4;
      memory = 1024;   # mínimo garantido (1 GB)
    };
  };

  boot.kernelParams = [
    "xen-dom0_mem=min:1024M,max:4096M"
    "xen-swiotlb=65536"
    "xen_scrub_pages=0"
  ];
}

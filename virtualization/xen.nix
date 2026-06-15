{ config, pkgs, lib, ... }:

{
  virtualisation.xen = {
    enable = true;

    dom0Resources = {
      memory = 4096;          # Começa com 4 GB (mínimo garantido)
      maxMemory = 16384;      # Máximo = toda a RAM do sistema (16 GB)
      maxVCPUs = 4;           # Usa todos os 4 núcleos
    };
  };

  boot.kernelParams = [
    "xen_scrub_pages=0"
    "xen-swiotlb=65536"
  ];
}

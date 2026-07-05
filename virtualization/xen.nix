{ config, pkgs, ... }:

{
  virtualisation.xen = {
    enable = true;
    dom0Resources = {
      memory = 4096;        
      maxVCPUs = 4;        
    };
    boot.params = [
      "dom0_mem=4096M dom0_max_vcpus=4"
      "iommu=on intel_iommu=on"
    ];
  };
}

{ config, lib, pkgs, ... }:

{
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;      
    priority = 50;        
  };

  swapDevices = [
    {
      device = "/dev/zvol/rpool/encrypted/system/swap";
      priority = 10;      
    }
  ];

  boot.kernel.sysctl = {
    "vm.swappiness" = 100;
    "vm.page-cluster" = 0;  
    "vm.dirty_ratio" = 30;        
    "vm.dirty_background_ratio" = 10;
    "vm.dirty_expire_centisecs" = 6000;  #
    "vm.dirty_writeback_centisecs" = 500;  
  };
}

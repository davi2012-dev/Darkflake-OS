{ config, lib, pkgs, ... }:

{
  # 1. ZRAM (Swap ultra-rápido na RAM)
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
    priority = 50; # Prioridade máxima para ser usado antes do disco
  };

  # 2. ZVOL ZFS (Swap de 16 GB no SSD como segunda camada)
  swapDevices = [
    {
      device = "/dev/zvol/rpool/encrypted/system/swap";
      priority = 10; # Prioridade menor que a ZRAM para ser usado apenas como "estepe"
    }
  ];

  # 3. Ajustes do Kernel (Otimização para o combo ZRAM + ZVOL)
  boot.kernel.sysctl = {
    # Com ZRAM, swappiness alto é ótimo.
    "vm.swappiness" = 100;
    # Importante: mude para 1 (ou tire) se usar ZVOL! 
    # '0' desativa o read-ahead completamente, o que é ótimo para ZRAM, 
    # mas pode deixar o swap em disco (ZVOL) um pouco arrastado ao ler páginas contíguas.
    "vm.page-cluster" = 1;
  };
}

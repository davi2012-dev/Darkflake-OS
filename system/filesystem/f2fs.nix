{ config, pkgs, ... }: {
  # 1. Suporte no Kernel e ferramentas de sistema
  # Adiciona os utilitários para formatar (mkfs.f2fs) e reparar (fsck.f2fs)
  boot.supportedFilesystems = [ "f2fs" ];
  
  environment.systemPackages = with pkgs; [
    f2fs-tools
  ];

  # 2. Otimização para SSD/Flash (Se o seu / for F2FS)
  # 'atgc': Adaptive Town Garbage Collection (ajuda muito na vida útil do disco)
  # 'gc_merge': Melhora o desempenho do Garbage Collector
  fileSystems."/".options = [ "noatime" "compress_algorithm=zstd" "compress_chksum" "atgc" "gc_merge" ];

  # 3. Tuning do Kernel para F2FS
  # Evita que o sistema tente gravar dados pequenos demais toda hora
  boot.kernel.sysctl = {
    "vm.dirty_background_ratio" = 5;
    "vm.dirty_ratio" = 10;
  };
}

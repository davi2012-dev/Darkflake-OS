{ config, pkgs, ... }: {

  # --- Sistema de Arquivos e Saúde do Disco ---
  fileSystems."/".options = [ "subvol=@" "compress=zstd" "noatime" "discard=async" ];
  
  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly"; # Verifica a saúde dos dados toda semana
  };

  # --- Otimização de Espaço (Deduplicação) ---
  services.beesd.instances = {
    main = {
      spec = "LABEL=fedora"; # Lembre de conferir se o Label é este mesmo!
      hashTableSizeMB = 256;
      verbosity = "critical";
    };
  };
 }

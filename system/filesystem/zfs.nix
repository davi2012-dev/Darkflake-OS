{ config, pkgs, lib, ... }: {

  networking.hostId = "cdb22960"; 

  # --- Configurações do Boot e Kernel ---
  boot.supportedFilesystems = [ "zfs" ];
  boot.initrd.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev/disk/by-id";
  boot.zfs.requestEncryptionCredentials = true;
  boot.zfs.forceImportRoot = true; 

  # --- Serviços do ZFS ---
  services.zfs.autoScrub = {
    enable = true;
    pools = [ "rpool" ];
    interval = "Mon,Wed,Fri,Sun *-*-* 12:00:00";
  };

  services.zfs.trim.enable = true; 

  # Configuração do ZED (ZFS Event Daemon) integrada
  services.zfs.zed.settings = {
    ZED_NOTIFY_VERBOSE = true;
  };

  # --- Automação de Snapshots (Sanoid) ---
  services.sanoid = {
    enable = true;
    interval = "minutely"; 
    datasets = {
      "rpool/encrypted/data/home"     = { hourly = 24; daily = 7;  monthly = 3; autosnap = true; autoprune = true; };
      "rpool/encrypted/data/projects" = { daily = 30;  monthly = 6; autosnap = true; autoprune = true; };
      "rpool/encrypted/data/games"    = { daily = 3;   hourly = 0;  monthly = 0; autosnap = true; autoprune = true; };
      "rpool/encrypted/data/media"    = { daily = 2;   hourly = 0;  monthly = 0; autosnap = true; autoprune = true; };
    };
  };
}

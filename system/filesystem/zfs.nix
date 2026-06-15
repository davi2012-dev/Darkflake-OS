{ config, pkgs, lib, ... }: {

  networking.hostId = "cdb22960"; 

  boot.supportedFilesystems = [ "zfs" ];
  boot.initrd.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev/disk/by-id";
  boot.zfs.requestEncryptionCredentials = true;
  boot.zfs.forceImportRoot = true; 
  
  services.zfs.autoScrub.enable = true;
  services.zfs.trim.enable = true;
  boot.kernelParams = [ "zfs.zfs_arc_max=8589934592" ]; 

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

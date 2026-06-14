{ pkgs, ... }: {
  boot.supportedFilesystems = [ "vfat" ];
  
  environment.systemPackages = [ pkgs.dosfstools ];
}

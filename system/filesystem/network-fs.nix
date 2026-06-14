{ config, pkgs, ... }: {
  boot.supportedFilesystems = [ "cifs" "nfs" ];

  environment.systemPackages = with pkgs; [
    cifs-utils # Para montar compartilhamentos Windows/Samba
    nfs-utils  # Para montar compartilhamentos Linux
  ];
}

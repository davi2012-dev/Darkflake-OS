{ pkgs, ... }: {
  boot.supportedFilesystems = [ "exfat" "ntfs" ];
  
  environment.systemPackages = with pkgs; [
    exfatprogs # Ferramentas modernas para exFAT
    ntfs3g     # Driver clássico NTFS
  ];
}

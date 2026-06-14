{ config, pkgs, ... }: {
  boot.supportedFilesystems = [ "vfat" "exfat" ];

  environment.systemPackages = with pkgs; [
    dosfstools      # mkfs.vfat, fsck.vfat
    exfatprogs      # O novo padrão para exFAT (mais rápido que o antigo fuse-exfat)
    mtools          # Manipula discos MS-DOS sem precisar montar (útil pra scripts)
  ];
}

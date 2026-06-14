{ ... }: {
  imports = [
    ./swap.nix         # Swap
    #./lvm.nix          # Volumes Lógicos
    #./f2fs.nix         # Flash Power
    #./erofs.nix        # Android System
    #./fat-modern.nix   # FAT32 e exFAT modernos
    #./ext4.nix         # O padrão
    #./legacy.nix       # JFS e ReiserFS (Os dinossauros)
    #./network-fs.nix   # Samba e NFS
    ./zfs.nix        # Ative se usar
     #./btrfs.nix      # Ative se usar
    # ./xfs.nix
    #./luks.nix
    ./automount.nix
  ];
}

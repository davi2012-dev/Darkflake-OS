{ config, pkgs, ... }:

{
  # 1. Habilita o suporte ao XFS no Kernel
  boot.supportedFilesystems = [ "xfs" ];

  # 2. Ferramentas essenciais para gerenciar XFS (mkfs.xfs, xfs_repair, xfs_growfs)
  environment.systemPackages = with pkgs; [
    xfsprogs
    xfsdump # Ferramenta de backup de alto nível para XFS
  ];

  # 3. Otimizações de Kernel para XFS (Melhora a escrita em paralelo)
  boot.kernel.sysctl = {
    "fs.xfs.xfssyncd_centisecs" = 3000; # Aumenta o tempo de flush para poupar o HD
  };

  # Nota: Quando você for montar sua partição XFS no hardware-configuration.nix
  # ou no seu configuration.nix, use essas opções para máxima performance:
  # fileSystems."/caminho/da/montagem" = {
  #   device = "/dev/disk/by-uuid/SEU-UUID";
  #   fsType = "xfs";
  #   options = [ 
  #     "noatime"    # Não escreve data de acesso (poupa o disco)
  #     "logbufs=8"  # Aumenta buffers de log na RAM para performance
  #     "logbsize=256k" 
  #     "allocsize=64m" # Ideal para evitar fragmentação em arquivos grandes
  #   ];
  # };
}

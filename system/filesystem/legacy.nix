{ config, pkgs, ... }: {
  # Ativa o suporte no Kernel
  boot.supportedFilesystems = [ "jfs" "reiserfs" ];

  # Ferramentas para formatar e consertar
  environment.systemPackages = with pkgs; [
    jfsutils
    reiserfsprogs
  ];
}

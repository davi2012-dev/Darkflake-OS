{ pkgs, ... }: {
  # O motor que permite falar com os discos sem ser root
  services.udisks2.enable = true;

  # Serviço para montar automaticamente qualquer disco/pendrive
  # Isso funciona no background, independente de interface gráfica
  services.devmon.enable = true;

  # Pacotes úteis para gerenciar montagem manual se precisar
  environment.systemPackages = with pkgs; [
    udiskie # Excelente para automount e tray icon
    udisks # Ferramentas de linha de comando (udisksctl)
  ];

  # Configuração extra para garantir que sistemas de arquivos comuns funcionem
  boot.supportedFilesystems = [ "ntfs" "exfat" "btrfs" "ext4" "vfat" ];
}

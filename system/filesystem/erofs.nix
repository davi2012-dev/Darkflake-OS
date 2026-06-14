{ pkgs, ... }: {
  boot.supportedFilesystems = [ "erofs" ];
  
  # Ferramentas para criar ou extrair imagens EROFS
  environment.systemPackages = [ pkgs.erofs-utils ];
}

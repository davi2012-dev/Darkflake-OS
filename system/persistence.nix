{ config, pkgs, lib, ... }:

{
  preservation.storage."/persist" = {
    # Diretórios do sistema (globais)
    directories = [
      "/var/lib"
      "/etc/NetworkManager/system-connections"
    ];
    files = [
      "/etc/machine-id"
    ];

    # Configuração para o usuário davi
    users.davi = {
      directories = [
        "Downloads"
        "Documents"
        ".config/sops/age"   # <-- Chave Age persistente
        ".local/share/keyrings"
        ".ssh"
      ];
      files = [
        ".bashrc"
        ".zshrc"
      ];
    };
  };
}

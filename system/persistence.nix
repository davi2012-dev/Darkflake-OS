{ config, pkgs, lib, ... }:

{
  preservation.storage."/persist" = {
    directories = [
      "/var/lib"
      "/etc/NetworkManager/system-connections"
    ];
    files = [
      "/etc/machine-id"
    ];

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

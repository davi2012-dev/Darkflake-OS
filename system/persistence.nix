{ config, pkgs, lib, ... }:

{
  preservation.storage."/persist" = {
    # Diretórios do sistema (globais) que devem ser persistidos
    directories = [
      "/var/lib"                     # Dados de serviços (systemd, libvirt, docker, etc.)
      "/etc/NetworkManager/system-connections"  # Redes salvas
      "/etc/ssh"                     # Chaves do servidor SSH (se você usa)
      "/etc/nixos"                   # Configuração do NixOS (opcional, se você quiser versionar de outra forma)
    ];
    files = [
      "/etc/machine-id"              # ID da máquina
      "/etc/hostname"                # Nome do host
      "/etc/localtime"               # Fuso horário
      "/etc/timezone"                # Zona de tempo
      "/etc/adjtime"                 # Ajustes de relógio
      "/etc/crypttab"                # Se usar criptografia de disco (mas você já tem ZFS encryption)
    ];

    # Configuração para o usuário davi
    users.davi = {
      directories = [
        "Downloads"
        "Documents"
        "Pictures"
        "Videos"
        "Music"
        "Public"
        "Templates"
        ".config/sops/age"            # Chave Age persistente
        ".local/share/keyrings"       # Chaves do GNOME/KDE
        ".ssh"                        # Chaves SSH
        ".gnupg"                      # Chaves GPG
        ".local/share/containers"     # Dados de containers (podman/docker)
        ".local/share/flatpak"        # Dados do flatpak (se usado)
        ".local/share/nixbit"         # Se você usa nixbit (pelo contexto)
        ".cache"                      # Cache do usuário (opcional – depende se você quer manter)
      ];
      files = [
        ".bashrc"
        ".zshrc"
        ".profile"
        ".gitconfig"
        ".config/user-dirs.dirs"      # Pastas padrão do XDG
        ".config/user-dirs.locale"    # Localização
        ".local/state/wireplumber"    # Configuração de áudio (pipewire/wireplumber)
      ];
    };

    # Configuração para o usuário guest (se você quiser persistir dados dele)
    users.guest = {
      directories = [
        "Downloads"
        ".ssh"
      ];
      files = [
        ".bashrc"
      ];
    };
  };
}

{ config, pkgs, ... }:

{
  preservation = {
    enable = true;

    preserveAt."/persist" = {
      directories = [
        "/var/lib"
        "/etc/NetworkManager/system-connections"
        "/etc/ssh"
        "/etc/nixos"
        "/home/games"
        "/home/jellyfin"
      ];

      files = [
        "/etc/machine-id"
        "/etc/hostname"
        "/etc/localtime"
        "/etc/timezone"
        "/etc/adjtime"
        "/etc/crypttab"
      ];

      users = {
        davi = {
          directories = [
            "Downloads"
            "Documents"
            "Pictures"
            "Videos"
            "Music"
            "Public"
            "Templates"
            ".config/sops/age"
            ".local/share/keyrings"
            ".ssh"
            ".gnupg"
            ".local/share/containers"
            ".local/share/flatpak"
            ".local/share/nixbit"
            ".cache"
          ];
          files = [
            ".bashrc"
            ".zshrc"
            ".profile"
            ".gitconfig"
            ".config/user-dirs.dirs"
            ".config/user-dirs.locale"
          ];
        };

        guest = {
          directories = [
            "Downloads"
            ".ssh"
          ];
          files = [
            ".bashrc"
          ];
        };
      };
    };
  };
}

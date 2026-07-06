{
  disko.devices = {
    disk = {
      sda = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "fmask=0022" "dmask=0022" ];
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "rpool";
              };
            };
          };
        };
      };
      sdb = {
        type = "disk";
        device = "/dev/sdb";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "rpool";
              };
            };
          };
        };
      };
    };
    zpool = {
      rpool = {
        type = "zpool";
        # mode removido - disko cria stripe por padrão com múltiplos discos
        options = {
          ashift = "12";
          autotrim = "on";
        };
        datasets = {
          "encrypted" = {
            type = "zfs_fs";
            options = {
              encryption = "aes-256-gcm";
              keyformat = "passphrase";
              keylocation = "prompt";
              mountpoint = "none";
              compression = "on";
              atime = "off";
              recordsize = "128K";
            };
          };
          "encrypted/data" = {
            type = "zfs_fs";
            options = {
              mountpoint = "none";
              compression = "on";
              atime = "off";
              recordsize = "128K";
            };
          };
          "encrypted/data/home" = {
            type = "zfs_fs";
            options = {
              mountpoint = "/home";
              compression = "on";
              atime = "off";
              recordsize = "128K";
            };
          };
          "encrypted/data/games" = {
            type = "zfs_fs";
            options = {
              mountpoint = "/home/games";
              compression = "on";
              atime = "off";
              recordsize = "128K";
            };
          };
          "encrypted/data/jellyfin" = {
            type = "zfs_fs";
            options = {
              mountpoint = "/home/jellyfin";
              compression = "on";
              atime = "off";
              recordsize = "128K";
            };
          };
          "encrypted/data/media" = {
            type = "zfs_fs";
            options = {
              mountpoint = "/home/media";
              compression = "off";
              atime = "off";
              recordsize = "1M";
            };
          };
          "encrypted/data/projects" = {
            type = "zfs_fs";
            options = {
              mountpoint = "/home/projects";
              compression = "zstd-fast";
              atime = "off";
              recordsize = "16K";
            };
          };
          "encrypted/persist" = {
            type = "zfs_fs";
            options = {
              mountpoint = "/persist";
              compression = "zstd";
              atime = "off";
              recordsize = "128K";
            };
          };
          "encrypted/system" = {
            type = "zfs_fs";
            options = {
              mountpoint = "none";
              compression = "on";
              atime = "off";
              recordsize = "128K";
            };
          };
          "encrypted/system/gnu" = {
            type = "zfs_fs";
            options = {
              mountpoint = "/gnu";
              compression = "zstd-1";
              atime = "off";
              recordsize = "128K";
            };
          };
          "encrypted/system/nix" = {
            type = "zfs_fs";
            options = {
              mountpoint = "/nix";
              compression = "zstd-1";
              atime = "off";
              recordsize = "128K";
            };
          };
          "encrypted/system/root" = {
            type = "zfs_fs";
            options = {
              mountpoint = "/";
              compression = "on";
              atime = "off";
              recordsize = "128K";
            };
          };
          "encrypted/system/swap" = {
            type = "zfs_volume";
            size = "16G";
            options = {
              volsize = "16G";
              compression = "off";
            };
          };
          "encrypted/system/var" = {
            type = "zfs_fs";
            options = {
              mountpoint = "/var";
              compression = "lz4";
              atime = "off";
              recordsize = "128K";
            };
          };
          "encrypted/system/var/cache" = {
            type = "zfs_fs";
            options = {
              mountpoint = "/var/cache";
              compression = "lz4";
              atime = "off";
              recordsize = "128K";
            };
          };
          "encrypted/system/var/log" = {
            type = "zfs_fs";
            options = {
              mountpoint = "/var/log";
              compression = "zstd";
              atime = "off";
              recordsize = "128K";
            };
          };
        };
      };
    };
  };
}

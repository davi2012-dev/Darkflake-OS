{ config, pkgs, ... }: {
  services.fail2ban = {
    enable = true;
    banaction = "nftables";   # <-- ESSENCIAL (sem -multiport)

    # Substitua daemonConfig por daemonSettings
    daemonSettings = {
      Definition.nftables = "/run/current-system/sw/bin/nft";
    };

    maxretry = 5;
    bantime = "24h";
    bantime-increment = {
      enable = true;
      multipliers = "1 2 4 8 16 32 64";
      maxtime = "43800000000000h";
    };

    jails.sshd.settings = {
      enabled = true;
      port = "ssh";
      filter = "sshd";
      maxretry = 3;
      backend = "systemd";
      banaction = "nftables";   # reforço
    };
  };
}

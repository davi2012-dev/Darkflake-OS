{ config, pkgs, ... }: {
  services.fail2ban = {
    enable = true;

    # Ação global: usaremos a customizada
    banaction = "nftables-drop";

    maxretry = 5;
    bantime = "24h";
    bantime-increment = {
      enable = true;
      multipliers = "1 2 4 8 16 32 64";
      maxtime = "43800000000000h";
    };

    # Definição da ação customizada
    actions = {
      "nftables-drop" = {
        description = "Ban IP using nftables with drop (no reject)";
        actionstart = ''
          nft add table inet f2b-table 2>/dev/null || true
          nft add chain inet f2b-table f2b-chain { type filter hook input priority -1 \; } 2>/dev/null || true
          nft add set inet f2b-table addr-set-sshd { type ipv4_addr \; } 2>/dev/null || true
        '';
        actionban = ''
          nft add element inet f2b-table addr-set-sshd { <ip> }
          nft add rule inet f2b-table f2b-chain ip saddr @addr-set-sshd drop
        '';
        actionunban = ''
          nft delete element inet f2b-table addr-set-sshd { <ip> }
        '';
        actionstop = ''
          nft flush chain inet f2b-table f2b-chain
          nft delete chain inet f2b-table f2b-chain
          nft delete table inet f2b-table
        '';
      };
    };

    jails.sshd.settings = {
      enabled = true;
      port = "ssh";
      filter = "sshd";
      maxretry = 3;
      backend = "systemd";
      banaction = "nftables-drop";   # força a customizada
    };
  };
}

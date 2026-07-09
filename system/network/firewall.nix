{ config, pkgs, lib, ... }:

{
  networking.firewall.enable = false;

  networking.nftables = {
    enable = true;
    checkRuleset = true;

    tables = {
      filter = {
        family = "inet";
        content = ''
          chain input {
            type filter hook input priority 10; policy drop;

            iifname { lo, waydroid0, tailscale0, podman*, veth*, proton*, wg*, tun*, pvpn* } accept
            ct state { established, related } accept

            # === PORTAS EXTERNAS ===
            tcp dport { 22, 53, 80, 139, 443, 445, 631, 4460, 51820, 8080, 3000, 8123, 9090, 8083, 53317 } accept

            udp dport { 53, 123, 4460, 631, 5353, 41641 3544  } accept

            icmp type echo-request accept
            icmpv6 type echo-request accept

            tcp flags & (fin|syn|rst|ack) == syn ct count over 500 drop
            tcp flags & (fin|syn|rst|ack) == rst ct count over 20 drop
            tcp flags & (fin|syn|rst|psh|ack|urg) == 0 drop
            tcp flags & (fin|syn|rst|psh|ack|urg) == fin|syn|rst|psh|ack|urg drop

            tcp flags & (fin|syn|rst|ack) == syn log prefix "refused connection: " level info
          }

          chain forward {
            type filter hook forward priority 0; policy drop;
            ct state invalid drop
          }

          chain output {
            type filter hook output priority 0; policy accept;
          }
        '';
      };
    };
  };

  networking.hosts = {
    "127.0.0.1" = [
      "nextcloud.darkflake.local"
      "jellyfin.darkflake.local"
      "search.darkflake.local"
      "adguard.darkflake.local"
      "librechat.darkflake.local"
      "cockpit.darkflake.local"
      "homarr.darkflake.local"
      "stirling.darkflake.local"
      "chat.darkflake.local"
      "metube.darkflake.local"
      "netdata.darkflake.local"
      "ha.darkflake.local"
      "portainer.darkflake.local"
    ];
    "::1" = [
      "nextcloud.darkflake.local"
      "jellyfin.darkflake.local"
      "search.darkflake.local"
      "librechat.darkflake.local"
      "cockpit.darkflake.local"
      "Adguard.darkflake.local"
      "homarr.darkflake.local"
      "stirling.darkflake.local"
      "chat.darkflake.local"
      "metube.darkflake.local"
      "netdata.darkflake.local"
      "ha.darkflake.local"
      "portainer.darkflake.local"
    ];
  };

  boot.kernel.sysctl = {
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr3";
    "net.ipv4.tcp_fastopen" = 3;
    "net.ipv4.tcp_sack" = 1;
    "net.ipv4.tcp_window_scaling" = 1;
    "net.ipv4.tcp_frto" = 2;
    "net.core.rmem_max" = 134217728;
    "net.core.wmem_max" = 134217728;
    "net.ipv4.tcp_rmem" = "4096 87380 134217728";
    "net.ipv4.tcp_wmem" = "4096 65536 134217728";
    "net.ipv4.icmp_echo_ignore_all" = 0;
    "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
    "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
    "net.ipv4.icmp_ratelimit" = 100;
    "net.ipv4.ip_forward" = 1;
    "net.ipv4.conf.all.rp_filter" = 1;
    "net.ipv4.conf.default.rp_filter" = 1;
    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv4.conf.default.accept_source_route" = 0;
    "net.ipv4.tcp_mtu_probing" = 1;
    "net.ipv4.tcp_retries1" = 3;
    "net.ipv4.tcp_retries2" = 8;
    "net.ipv4.tcp_max_orphans" = 65536;
    "net.ipv4.ip_local_reserved_ports" = "22,53,80,139,443,445,631,4460,51820,8080,3000,8123,9090,8083,53317";
    "net.ipv4.ip_local_port_range" = "1024 65000";
    "net.core.somaxconn" = 8192;
    "net.ipv4.conf.all.log_martians" = 1;
    "net.ipv4.conf.default.log_martians" = 1;
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv6.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.default.accept_redirects" = 0;
    "net.ipv6.conf.all.forwarding" = 1;
    "net.ipv6.conf.all.accept_source_route" = 0;
    "net.ipv6.conf.default.accept_source_route" = 0;
    "net.ipv4.conf.all.secure_redirects" = 0;
    "net.ipv4.conf.all.shared_media" = 0;
    "net.ipv4.igmp_max_memberships" = 100;
    "net.core.netdev_max_backlog" = 250000;
    "net.ipv4.tcp_syncookies" = 1;
    "net.ipv4.tcp_synack_retries" = 1;
    "net.ipv4.tcp_syn_retries" = 2;
    "net.ipv4.tcp_max_syn_backlog" = 65536;
    "net.ipv4.tcp_rfc1337" = 1;
    "net.ipv4.tcp_fin_timeout" = 30;
    "net.ipv4.tcp_orphan_retries" = 3;
    "net.ipv4.tcp_timestamps" = 1;
    "net.ipv4.tcp_slow_start_after_idle" = 0;
    "net.ipv4.tcp_notsent_lowat" = 16384;
  };
}

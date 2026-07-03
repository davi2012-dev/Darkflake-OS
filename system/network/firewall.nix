{ config, pkgs, ... }: {
  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    allowPing = true; 
    logRefusedConnections = true;
    rejectPackets = false;
    checkReversePath = "strict";

    allowedTCPPorts = [ 
      22 53 80 139 443 445 631 4460 51820 8080 3000 8123 9090 8083 53317
    ];

    allowedUDPPorts = [ 
      53 123 4460 631 5353 41641
    ];

    trustedInterfaces = [ "waydroid0" "tailscale0" "lo" "podman+" "veth+" "proton+" "wg+" "tun+" "pvpn+" ];

    extraInputRules = ''
      ct state invalid drop

      tcp flags & (fin|syn|rst|ack) == syn ct count over 500 drop comment "anti-syn-flood"
      tcp flags & (fin|syn|rst|ack) == rst ct count over 20 drop comment "anti-rst-flood"
      
      tcp flags & (fin|syn|rst|psh|ack|urg) == 0 drop comment "anti-null-scan"
      tcp flags & (fin|syn|rst|psh|ack|urg) == fin|syn|rst|psh|ack|urg drop comment "anti-xmas-scan"

      meta l4proto tcp ct state new tcp dport != { ${builtins.concatStringsSep "," (map toString config.networking.firewall.allowedTCPPorts)} } \
        limit rate over 2/minute burst 3 packets drop comment "tarpit-silencioso"
    '';

    extraForwardRules = ''
      ct state invalid drop
    '';
  };

  boot.kernel.sysctl = {
    # Redes e Performance Extrema
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr3";
    "net.ipv4.tcp_fastopen" = 3;
    "net.ipv4.tcp_sack" = 1;
    "net.ipv4.tcp_window_scaling" = 1;
    "net.ipv4.tcp_frto" = 2;
    
    # Proteção ICMP
    "net.ipv4.icmp_echo_ignore_all" = 0; 
    "net.ipv4.icmp_echo_ignore_broadcasts" = 1; 
    "net.ipv4.icmp_ignore_bogus_error_responses" = 1; 
    "net.ipv4.icmp_ratelimit" = 100; 
    
    # Roteamento
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

    # Logs
    "net.ipv4.conf.all.log_martians" = 1;
    "net.ipv4.conf.default.log_martians" = 1;

    # Redirecionamentos
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.v6.conf.all.accept_redirects" = 0;
    "net.v6.conf.default.accept_redirects" = 0;
    "net.v6.conf.all.forwarding" = 1; 
    "net.v6.conf.all.accept_source_route" = 0;
    "net.v6.conf.default.accept_source_route" = 0;
    "net.ipv4.conf.all.secure_redirects" = 0;
    "net.ipv4.conf.all.shared_media" = 0;
    "net.ipv4.igmp_max_memberships" = 100;

    # SYN Flood
    "net.core.netdev_max_backlog" = 250000;
    "net.ipv4.tcp_syncookies" = 1;
    "net.ipv4.tcp_synack_retries" = 1;
    "net.ipv4.tcp_syn_retries" = 2;
    "net.ipv4.tcp_max_syn_backlog" = 65536; 
    "net.ipv4.tcp_rfc1337" = 1;              
    
    # Gerenciamento de conexões
    "net.ipv4.tcp_fin_timeout" = 30;
    "net.ipv4.tcp_orphan_retries" = 3;
    "net.ipv4.tcp_timestamps" = 1;
    "net.ipv4.tcp_slow_start_after_idle" = 0;
  };
}

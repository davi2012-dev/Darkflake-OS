{ config, pkgs, ... }: {
  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;

    allowPing = true; 
    logRefusedConnections = true;
    rejectPackets = false; # Stealth mode ativo (DROP por padrão)
    checkReversePath = "loose";

    # Portas limpas de duplicatas
    allowedTCPPorts = [ 
      22    # SSH
      53    # DNS
      80    # HTTP
      139   # Samba
      443   # HTTPS
      445   # Samba
      631   # CUPS (Impressão)
      53317
      4460  # NTS 
      51820 # vpn
      8080  # SEARXNG ( buscador local)
      3000  # Gitea / Aplicações Dev
      8123  # Home Assistant
      9090  # Cockpit / Prometheus
      8083  
    ];

    allowedUDPPorts = [ 
      53    # DNS
      123   # NTP
      4460  # NTS 
      631   # CUPS
      5353  # mDNS (Avahi)
      41641 # Tailscale
    ];

    trustedInterfaces = [ "waydroid0" "tailscale0" "lo" "podman+" "veth+" "proton+" "wg+" "tun+" "pvpn+"  ];

    extraInputRules = ''
      # Bloqueia pacotes inválidos imediatamente
      ct state invalid drop

      # Proteção contra Port Scans e DoS (SYN / RST Flood)
      tcp flags & (fin|syn|rst|ack) == syn ct count over 500 drop comment "anti-syn-flood"
      tcp flags & (fin|syn|rst|ack) == rst ct count over 20 drop comment "anti-rst-flood"
      
      tcp flags & (fin|syn|rst|psh|ack|urg) == 0 drop comment "anti-null-scan"
      tcp flags & (fin|syn|rst|psh|ack|urg) == fin|syn|rst|psh|ack|urg drop comment "anti-xmas-scan"

      # Tarpit/Rate-limit silencioso para portas TCP fechadas antes de caírem na política padrão
      # Nota: Removemos o drop cego no final para não interceptar as portas abertas pelo NixOS
      meta l4proto tcp ct state new tcp dport != { ${builtins.concatStringsSep "," (map toString config.networking.firewall.allowedTCPPorts)} } \
        limit rate over 2/minute burst 3 packets drop comment "tarpit-silencioso"
    '';

    extraForwardRules = ''
      ct state invalid drop
    '';
  };

  boot.kernel.sysctl = {
    # Redes e Performance (BBR + FQ)
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.ipv4.tcp_fastopen" = 3;
    
    # Proteção ICMP
    "net.ipv4.icmp_echo_ignore_all" = 0; 
    "net.ipv4.icmp_echo_ignore_broadcasts" = 1; 
    "net.ipv4.icmp_ignore_bogus_error_responses" = 1; 
    "net.ipv4.icmp_ratelimit" = 100; 
    
    # Roteamento e Anti-Spoofing
    "net.ipv4.ip_forward" = 1; # Ativo para Waydroid nativo
    "net.ipv4.conf.all.rp_filter" = 2;
    "net.ipv4.conf.default.rp_filter" = 2;
    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv4.conf.default.accept_source_route" = 0;

    # Mitigação de SYN Flood agressiva e unificação de limites
    "net.core.netdev_max_backlog" = 250000;
    "net.ipv4.tcp_syncookies" = 1;
    "net.ipv4.tcp_synack_retries" = 1;
    "net.ipv4.tcp_syn_retries" = 2;
    "net.ipv4.tcp_max_syn_backlog" = 65536; # Aumentado para suportar o backlog maior
    "net.ipv4.tcp_rfc1337" = 1;
    
    # Timeouts e gerenciamento de memória TCP
    "net.ipv4.tcp_fin_timeout" = 30;
    "net.ipv4.tcp_orphan_retries" = 3;
    "net.ipv4.tcp_timestamps" = 1; # Mantido obrigatório para SYN Cookies + BBR
    "net.ipv4.tcp_slow_start_after_idle" = 0;
  };
}


{ config, pkgs, ... }: {
  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    allowPing = true; 
    logRefusedConnections = true;
    rejectPackets = false; # Stealth mode ativo (DROP por padrão)
    checkReversePath = "strict";

    # Portas declaradas perfeitamente
    allowedTCPPorts = [ 
      22    # SSH
      53    # DNS
      80    # HTTP
      139   # Samba
      443   # HTTPS
      445   # Samba
      631   # CUPS (Impressão)
      4460  # NTS 
      51820 # VPN WireGuard
      8080  # SEARXNG
      3000  # Gitea / Aplicações Dev
      8123  # Home Assistant
      9090  # Cockpit
      8083  
      53317
    ];

    allowedUDPPorts = [ 
      53    # DNS
      123   # NTP
      4460  # NTS 
      631   # CUPS
      5353  # mDNS (Avahi)
      41641 # Tailscale
    ];

    # Interfaces virtuais de confiança que ignoram bloqueios internos
    trustedInterfaces = [ "waydroid0" "tailscale0" "lo" "podman+" "veth+" "proton+" "wg+" "tun+" "pvpn+" ];

    extraInputRules = ''
      # Bloqueia pacotes inválidos imediatamente
      ct state invalid drop

      # Proteção contra Port Scans e DoS (SYN / RST Flood)
      tcp flags & (fin|syn|rst|ack) == syn ct count over 500 drop comment "anti-syn-flood"
      tcp flags & (fin|syn|rst|ack) == rst ct count over 20 drop comment "anti-rst-flood"
      
      tcp flags & (fin|syn|rst|psh|ack|urg) == 0 drop comment "anti-null-scan"
      tcp flags & (fin|syn|rst|psh|ack|urg) == fin|syn|rst|psh|ack|urg drop comment "anti-xmas-scan"

      # Tarpit/Rate-limit silencioso para portas TCP fechadas antes de caírem na política padrão
      meta l4proto tcp ct state new tcp dport != { ${builtins.concatStringsSep "," (map toString config.networking.firewall.allowedTCPPorts)} } \
        limit rate over 2/minute burst 3 packets drop comment "tarpit-silencioso"
    '';

    extraForwardRules = ''
      ct state invalid drop
    '';
  };

  boot.kernel.sysctl = {
    # Redes e Performance Extrema (BBR v3 + FQ)
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr3";
    "net.ipv4.tcp_fastopen" = 3;
    "net.ipv4.tcp_sack = 1"
    "net.ipv4.tcp_window_scaling = 1"
    "net.ipv4.tcp_frto = 2"
    
    # Proteção contra ataques baseados em ICMP
    "net.ipv4.icmp_echo_ignore_all" = 0; 
    "net.ipv4.icmp_echo_ignore_broadcasts" = 1; 
    "net.ipv4.icmp_ignore_bogus_error_responses" = 1; 
    "net.ipv4.icmp_ratelimit" = 100; 
    
    # Roteamento essencial para o Waydroid + Anti-Spoofing Mitigado
    "net.ipv4.ip_forward" = 1; 
    "net.ipv4.conf.all.rp_filter" = 1;
    "net.ipv4.conf.default.rp_filter" = 1;
    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv4.conf.default.accept_source_route" = 0;

    # ADICIONADO: Ativa logs para pacotes falsificados/impossíveis (Cobrado pelo Lynis)
    "net.ipv4.conf.all.log_martians" = 1;
    "net.ipv4.conf.default.log_martians" = 1;
    "net.ipv4.tcp_rfc1337 = 1"

    # Correções extras de segurança de rede cobradas em auditorias (Lynis)
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

    # Mitigação de SYN Flood agressiva na fila do Kernel
    "net.core.netdev_max_backlog" = 250000;
    "net.ipv4.tcp_syncookies" = 1;
    "net.ipv4.tcp_synack_retries" = 1;
    "net.ipv4.tcp_syn_retries" = 2;
    "net.ipv4.tcp_max_syn_backlog" = 65536; 
    "net.ipv4.tcp_rfc1337" = 1;
    
    # Gerenciamento de Conexões Mortas e Ociosidade (Otimiza RAM)
    "net.ipv4.tcp_fin_timeout" = 30;
    "net.ipv4.tcp_orphan_retries" = 3;
    "net.ipv4.tcp_timestamps" = 1; # Obrigatório para BBR e validação de pacotes
    "net.ipv4.tcp_slow_start_after_idle" = 0;
  };
}

{ config, pkgs, lib, ... }:

{
  # Desabilita o firewall padrão do NixOS p
  networking.firewall.enable = false;

  # Ativa nftables e define a tabela personalizada
  networking.nftables = {
    enable = true;
    checkRuleset = true; # verifica sintaxe durante o build

    tables = {
      filter = {
        family = "inet";
        content = ''
          chain input {
            type filter hook input priority 10; policy drop;

            # Loopback e interfaces confiáveis
            iifname { lo, waydroid0, tailscale0, podman*, veth*, proton*, wg*, tun*, pvpn* } accept

            # Conexões já estabelecidas e relacionadas
            ct state { established, related } accept

            # Portas TCP permitidas
            tcp dport { 22, 53, 80, 139, 443, 445, 631, 4460, 51820, 8080, 3000, 8123, 9090, 8083, 53317 } accept

            # Portas UDP permitidas
            udp dport { 53, 123, 4460, 631, 5353, 41641 } accept

            # Ping (ICMP)
            icmp type echo-request accept
            icmpv6 type echo-request accept

            # Anti-DDoS
            tcp flags & (fin|syn|rst|ack) == syn ct count over 500 drop
            tcp flags & (fin|syn|rst|ack) == rst ct count over 20 drop
            tcp flags & (fin|syn|rst|psh|ack|urg) == 0 drop
            tcp flags & (fin|syn|rst|psh|ack|urg) == fin|syn|rst|psh|ack|urg drop

            # Tarpit para scanners lentos (opcional)
            meta l4proto tcp ct state new tcp dport != { 22,53,80,139,443,445,631,4460,51820,8080,3000,8123,9090,8083,53317 } \
              limit rate over 2/minute burst 3 packets drop

            # Log das conexões recusadas (opcional)
            tcp flags & (fin|syn|rst|ack) == syn log prefix "refused connection: " level info

            # Tudo que não foi aceito acima será dropado (já garantido por policy drop)
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

  # Sysctls – com mkForce para evitar duplicação
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
    "kernel.numa_balancing" = 0;
  };
}

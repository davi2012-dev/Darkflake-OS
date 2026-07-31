{ config, pkgs, ... }:
{
  services.adguardhome = {
    enable = true;
    settings = {
      http.address = "127.0.0.1:3000";
      dns = {
        bind_hosts = [
         "0.0.0.0"
         "::"
        ];
        port = 53;
        upstream_dns = [
          # ---- DoQ nativos ----
          "quic://unfiltered.adguard-dns.com"
          "quic://dns.quad9.net"
          "quic://dns.alidns.com"
          "quic://doq.ffmuc.net"
          "quic://dns.adguard-dns.com"          # (perfil filtrado da AdGuard)

          # ---- DoT ----
          "tls://one.one.one.one"               # (Cloudflare)
          "tls://dns.quad9.net"                 # (redundante com o DoQ acima, )
          "tls://dns.nextdns.io"                # (NextDNS, perfil padrão)
          "tls://p0.freedns.controld.com"       # (ControlD, resolver gratuito não filtrado)
          "tls://dns.google"                    # (Google)
          "tls://security-filter-dns.cleanbrowsing.org" # (CleanBrowsing)
          "tls://odvr.nic.cz"                   # (CZ.NIC ODVR)

          # ---- DoH ----
          "https://doh.opendns.com/dns-query"   #  (OpenDNS/Cisco, não tem DoT público)

          # ---- Sem suporte a criptografia ----
          "8.26.56.26"     # Comodo Secure DNS
          "156.154.70.1"   # Neustar/UltraDNS Public (DoH/DoT só sob contrato enterprise)
          "4.2.2.1"        # Level3 (legado)
          "64.6.64.6"      # Verisign (descontinuou DoT/DoH público)
          "209.244.0.3"    # Level3/CenturyLink
          "216.146.35.35"  # Dyn (Oracle, praticamente abandonado)
        ];
        fallback_dns = [
          # ---- DoQ ----
          "quic://dns.adguard-dns.com"

          # ---- DoT ----
          "tls://one.one.one.one"
          "tls://dns.quad9.net"
          "tls://dns.nextdns.io"
          "tls://p0.freedns.controld.com"
          "tls://dns.google"
          "tls://security-filter-dns.cleanbrowsing.org"
          "tls://odvr.nic.cz"

          # ---- DoH ----
          "https://doh.opendns.com/dns-query"

          # ---- Sem suporte a criptografia  ----
          "8.20.247.20"    # Comodo secundário
          "84.200.70.40"   # DNS.WATCH secundário
          "156.154.71.1"   # Neustar secundário
          "4.2.2.2"        # Level3 secundário
          "64.6.65.6"      # Verisign secundário
          "209.244.0.4"    # Level3/CenturyLink secundário
          "216.146.36.36"  # Dyn secundário
        ];
        # bootstrap_dns precisa continuar em texto puro: é usado pelo AdGuard Home
        # para resolver os hostnames dos upstreams DoT/DoH/DoQ acima, então não pode
        # depender deles mesmos (dependência circular).
        bootstrap_dns = [
          "8.8.8.8"
          "1.1.1.1"
          "9.9.9.9"
          "45.90.28.0"
          "208.67.222.222"
        ];
        private_reverse_dns_servers = [
          "1.1.1.1"
          "9.9.9.9"
          "100.100.100.100"
        ];
        upstream_dns_mode = "parallel";
        blocking_mode = "nxdomain";
        cache_size = 67108864;
        cache_ttl_min = 300;
        cache_ttl_max = 86400;
        fastest_addr = true;
        enable_dnssec = true;
        cache_optimistic = true;
        serve_stale = true;
        ratelimit = 20;
        refuse_any = true;
        filtering_enabled = true;
        protection_enabled = true;
        blocking_ipv4 = "";
        blocking_ipv6 = "";
      };
      statistics = {
        enabled = true;
        interval = "24h";
      };
      querylog = {
        enabled = true;
        interval = "24h";
        anon_ip = true;
      };
    };
  };
  # ===== HARDENING SYSTEMD PARA O ADGUARD HOME =====
  systemd.services.adguardhome = {
    serviceConfig = {
      # Isolamento de sistema e arquivos
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
      PrivateDevices = true;
      PrivateMounts = true;
      ProtectControlGroups = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "invisible";
      ProtectHostname = true;
      PrivateIPC = true;
      LockPersonality = true;
      # Proteção de memória e processos
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      RestrictNamespaces = true;
      ProcSubset = "all"; # Restringe /proc apenas a processos próprios
      # Restrições de rede e sistema
      RestrictAddressFamilies = [
        "AF_INET"
        "AF_INET6"
        "AF_UNIX"
      ];
      SystemCallArchitectures = "native";
      SystemCallFilter = [
        "@system-service"
        "~@privileged"
        "~@resources"
      ];
      # Capacidades: necessário CAP_NET_BIND_SERVICE para porta 53
      CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
      AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
    };
  };
}

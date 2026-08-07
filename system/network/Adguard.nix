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
          # ================= DoQ (4) =================
          "quic://unfiltered.adguard-dns.com"   # AdGuard, sem filtro
          "quic://dns.alidns.com"               # AliDNS (China, Alibaba)
          "quic://doq.ffmuc.net"                # FFMUC (Alemanha, Freifunk München)
          "quic://dns.surfsharkdns.com"         # Surfshark, sem bloqueio

          # ================= DoT (16) =================
          "tls://one.one.one.one"               # Cloudflare
          "tls://dns10.quad9.net"               # Quad9, variante sem filtro
          "tls://dns.nextdns.io"                # NextDNS, perfil padrão
          "tls://dns.google"                    # Google
          "tls://p0.freedns.controld.com"       # ControlD, sem filtro
          "tls://odvr.nic.cz"                   # CZ.NIC ODVR
          "tls://dns.mullvad.net"               # Mullvad, sem bloqueio
          "tls://dns.switch.ch"                 # SWITCH (Suíça, acadêmica)
          "tls://ordns.he.net"                  # Hurricane Electric
          "tls://private.canadianshield.cira.ca" # CIRA, privacidade sem bloqueio
          "tls://unfiltered.joindns4.eu"        # DNS4EU, sem filtro
          "tls://dot.libredns.gr"               # LibreDNS (Grécia)
          "tls://dns.digitale-gesellschaft.ch"  # Digitale Gesellschaft (Suíça)
          "tls://dns.alidns.com"                # AliDNS, DoT
          "tls://dnsforge.de"                   # DNS Forge (Alemanha)
          "tls://kaitain.restena.lu"             # RESTENA (Luxemburgo, acadêmica)

          # ================= DoH (21) =================
          "https://doh.opendns.com/dns-query"                  # OpenDNS/Cisco, padrão
          "https://cloudflare-dns.com/dns-query"                # Cloudflare
          "https://dns10.quad9.net/dns-query"                   # Quad9, sem filtro
          "https://dns.google/dns-query"                        # Google
          "https://dns.nextdns.io"                              # NextDNS, perfil padrão
          "https://freedns.controld.com/p0"                     # ControlD, sem filtro
          "https://odvr.nic.cz/doh"                             # CZ.NIC
          "https://dns.mullvad.net/dns-query"                   # Mullvad, sem bloqueio
          "https://dns.switch.ch/dns-query"                     # SWITCH
          "https://ordns.he.net/dns-query"                      # Hurricane Electric
          "https://private.canadianshield.cira.ca/dns-query"    # CIRA, sem bloqueio
          "https://unfiltered.joindns4.eu/dns-query"            # DNS4EU, sem filtro
          "https://doh.libredns.gr/dns-query"                   # LibreDNS
          "https://dns.digitale-gesellschaft.ch/dns-query"      # Digitale Gesellschaft
          "https://dns.alidns.com/dns-query"                    # AliDNS
          "https://dnsforge.de/dns-query"                       # DNS Forge
          "https://kaitain.restena.lu/dns-query"                # RESTENA
          "https://wikimedia-dns.org/dns-query"                 # Wikimedia Foundation
          "https://dns.surfsharkdns.com/dns-query"              # Surfshark
          "https://common.dot.dns.yandex.net/dns-query"         # Yandex, perfil básico sem filtro (Rússia )
          "https://resolver.dnsprivacy.org.uk/dns-query"        # DNS Privacy Project (Reino Unido)
        ];

        fallback_dns = [
          # ---- Sem suporte a criptografia secundários  ----
          "8.20.247.20"    # Comodo secundário
          "84.200.70.40"   # DNS.WATCH secundário
          "156.154.71.1"   # Neustar secundário
          "4.2.2.2"        # Level3 secundário
          "64.6.65.6"      # Verisign secundário
          "209.244.0.4"    # Level3/CenturyLink secundário
          "216.146.36.36"  # Dyn secundário
          "208.67.220.220" # OpenDNS/Cisco secundário
          "94.140.14.141"  # AdGuard DNS sem filtro, secundário
          "76.76.10.0"     # ControlD sem filtro, secundário
          "8.8.4.4"        # Google Public DNS, secundário
          "1.0.0.1"        # Cloudflare, secundário
          "149.112.112.10" # Quad9, variante sem filtro (9.9.9.10), secundário
          "149.112.122.10" # CIRA Canadian Shield "Private" (sem bloqueio), secundário
          "86.54.11.200"   # DNS4EU, perfil "unfiltered", secundário
        ];

        # bootstrap_dns precisa continuar em texto puro: é usado pelo AdGuard Home
        # para resolver os hostnames dos upstreams DoT/DoH/DoQ acima, então não pode
        # depender deles mesmos (dependência circular).
        bootstrap_dns = [
          "1.1.1.1"       # Cloudflare — sem filtro
          "8.8.8.8"       # Google — sem filtro
          "9.9.9.11"      # Quad9 — sem filtro + DNSSEC
          "94.140.14.140" # AdGuard DNS — variante unfiltered
        ];
        private_reverse_dns_servers = [
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
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      RestrictNamespaces = true;
      ProcSubset = "all";
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
      CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
      AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
    };
  };
}

{ config, pkgs, ... }:

{
  services.dnscrypt-proxy2 = {
    enable = true;

    settings = {
      listen_addresses = [
         "127.0.0.1:5354"
         "[::1]:5354"
      ];

      server_names = [
      "cloudflare-dnscrypt"
      "quad9-dnscrypt-main"
      "scaleway-fr"
      "adguard-dnscrypt"
      "dnscrypt.eu-dk"
      "dnscrypt.nl"
      "dnscrypt.de"
      "dns.digitale-gesellschaft.ch"
      "ffmuc.net"
      ];

      require_nofilter = true;
      require_nolog = true;
      require_dnssec = true;

      anonymized_dns = {
  routes = [
    { server_name = "cloudflare-dnscrypt"; via = [ "anon-cs-de" ]; }
    { server_name = "quad9-dnscrypt-main"; via = [ "anon-cs-nl" ]; }
    { server_name = "scaleway-fr"; via = [ "anon-cs-fr" ]; }
    { server_name = "adguard-dnscrypt"; via = [ "anon-cs-nl" ]; }
    { server_name = "dnscrypt.eu-dk"; via = [ "anon-cs-dk" ]; }
    { server_name = "dnscrypt.nl"; via = [ "anon-cs-nl" ]; }
    { server_name = "dnscrypt.de"; via = [ "anon-cs-de" ]; }
    { server_name = "dns.digitale-gesellschaft.ch"; via = [ "anon-cs-ch" ]; }
    { server_name = "ffmuc.net"; via = [ "anon-cs-de" ]; }
  ];
};

      force_tcp = false;
      ipv4_servers = true;
      ipv6_servers = false;

      cache = true;
      cache_size = 4096;
    };
  };

  systemd.services.dnscrypt-proxy.serviceConfig = {
    ProtectSystem = "strict";
    ProtectHome = true;
    PrivateTmp = true;
    ProtectControlGroups = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    NoNewPrivileges = true;
    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    MemoryDenyWriteExecute = true;

    CapabilityBoundingSet = [ "" ];
    AmbientCapabilities = [ "" ];

    SystemCallArchitectures = "native";
    SystemCallFilter = [
      "@system-service"
      "~@privileged"
      "~@resources"
    ];
  };
}

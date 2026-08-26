{
  pkgs,
  lib,
  ...
}: let
  hasIPv6Internet = true;
  StateDirName = "dnscrypt-proxy";
  StatePath = "/var/lib/${StateDirName}";
in {
  services.dnscrypt-proxy = {
    enable = true;
    settings = {
      listen_addresses = [ "127.0.0.1:5453" ];

      sources.odoh-servers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/odoh-servers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/odoh-servers.md"
        ];
        cache_file = "${StatePath}/odoh-servers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };

      sources.odoh-relays = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/odoh-relays.md"
          "https://download.dnscrypt.info/resolvers-list/v3/odoh-relays.md"
        ];
        cache_file = "${StatePath}/odoh-relays.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };

      server_names = [ "odoh-cloudflare" "odoh-snowstorm" ];

      anonymized_dns = {
        skip_incompatible = true;
        routes = [
          {
            server_name = "odoh-snowstorm";
            via = [ "odohrelay-crypto-sx" ];
          }
          {
            server_name = "odoh-cloudflare";
            via = [ "odohrelay-crypto-sx" ];
          }
        ];
      };

      ipv6_servers = hasIPv6Internet;
      block_ipv6 = !hasIPv6Internet;
      require_dnssec = true;
      require_nolog = false;
      require_nofilter = false;
      odoh_servers = true;
      dnscrypt_servers = false;
    };
  };

  systemd.services.dnscrypt-proxy2.serviceConfig.StateDirectory = StateDirName;
}

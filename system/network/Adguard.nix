{ config, pkgs, ... }:

{
  services.adguardhome = {
    enable = true;

    settings = {
      http.address = "127.0.0.1:3000";

      dns = {
        bind_hosts = [
          "127.0.0.1"
          "192.168.0.119"
          "10.0.3.1"
          "10.88.0.1"
          "::1"
        ];
        port = 53;

        upstream_dns = [
          "127.0.0.1:5354"
          "127.0.0.1:5335"
          "1.1.1.1"
          "9.9.9.9"
          "8.26.56.26"
          "156.154.70.1"
          "4.2.2.1"
          "45.90.28.0"
          "76.76.2.0"
          "8.8.8.8"
          "94.140.14.14"
          "185.228.168.9"
          "208.67.222.222"
          "64.6.64.6"
          "209.244.0.3"
          "216.146.35.35"
          "193.17.47.1"
        ];

        fallback_dns = [
          "1.0.0.1"
          "149.112.112.112"
          "8.20.247.20"
          "84.200.70.40"
          "156.154.71.1"
          "4.2.2.2"
          "45.90.30.0"
          "8.8.4.4"
          "76.76.10.0"
          "94.140.15.15"
          "185.228.169.9"
          "208.67.220.220"
          "64.6.65.6"
          "209.244.0.4"
          "216.146.36.36"
          "185.43.135.1"
        ];

        bootstrap_dns = [
          "127.0.0.1:5354"
          "127.0.0.1:5335"
          "1.1.1.1"
          "9.9.9.9"
        ];

        private_reverse_dns_servers = [
          "127.0.0.1:5354"
          "127.0.0.1:5335"
          "1.1.1.1"
          "9.9.9.9"
        ];

        upstream_dns_mode = "parallel";
        blocking_mode = "nxdomain";
        cache_size = 67108864;
        cache_ttl_min = 300;
        cache_ttl_max = 86400;
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
}

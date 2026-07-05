{ config, pkgs, ... }: {

  services.adguardhome = {
    enable = true;

    settings = {
      http.address = "127.0.0.1:3000";

      dns = {
        bind_hosts = [ "10.88.0.1" "127.0.0.1" "::1" "waydroid0" ];
        port = 53;

        upstream_dns = [
          "127.0.0.1:5335"
        ];

        bootstrap_dns = [
          "127.0.0.1:5335"
        ];

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

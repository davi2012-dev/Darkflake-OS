{ config, pkgs, ... }:

{
  services.unbound = {
    enable = true;
    settings = {
      server = {
        interface = [ "127.0.0.1" "::1" ];
        port = 5335;

        access-control = [
          "127.0.0.0/8 allow"
          "::1/128 allow"
        ];

        num-threads = 4;
        so-reuseport = true;
        msg-cache-slabs = 4;
        rrset-cache-slabs = 4;
        infra-cache-slabs = 4;
        key-cache-slabs = 4;
        msg-cache-size = "64m";
        rrset-cache-size = "128m";
        key-cache-size = "32m";
        neg-cache-size = "32m";
        cache-min-ttl = 300;
        cache-max-ttl = 86400;
        prefetch = true;
        prefetch-key = true;
        serve-expired = true;
        serve-expired-ttl = 86400;
        rrset-roundrobin = true;
        infra-cache-numhosts = 10000;
        infra-keep-probing = true;
        unknown-server-time-limit = 500;
        so-rcvbuf = "8m";
        so-sndbuf = "8m";

        do-ip4 = true;
        do-ip6 = true;
        prefer-ip6 = true;
        module-config = "dns64 validator iterator";
        dns64-prefix = "64:ff9b::/96";
        dns64-synthall = yes;
        edns-buffer-size = 1232;
        unwanted-reply-threshold = 10000;
        root-hints = "${pkgs.dns-root-data}/root.hints";

        auto-trust-anchor-file = "/var/lib/unbound/root.key";
        harden-glue = true;
        harden-dnssec-stripped = true;
        harden-below-nxdomain = true;
        harden-referral-path = true;
        harden-algo-downgrade = true;
        harden-short-bufsize = true;
        aggressive-nsec = true;
        deny-any = true;
        val-clean-additional = true;

        qname-minimisation = true;
        minimal-responses = true;
        hide-identity = true;
        hide-version = true;
        hide-trustanchor = true;
        use-caps-for-id = true;
        do-not-query-localhost = false;
        tls-cert-bundle = "/etc/ssl/certs/ca-certificates.crt";

        tls-ciphers = "ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305";

        tls-use-sni = true;
        verbosity = 1;
        harden-large-queries = true;
      };
    };
  };
}

{ config, pkgs, ... }:

{
  # 1. IMPORTANTE: Permissão para ler o socket
  users.users.unbound.extraGroups = [ "redis" ];

  services.unbound = {
    enable = true;
    
    # O PULO DO GATO: Diz ao módulo para injetar o suporte ao Redis automaticamente
    enableRedis = true;

    settings = {
      server = {
        interface = [ "127.0.0.1" "::1" ];
        port = 5335;

        access-control = [
          "127.0.0.0/8 allow"
          "::1/128 allow"
        ];

        # Módulos na ordem correta
        module-config = "validator cachedb iterator";

        # PERFORMANCE
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

        # REDE
        do-ip4 = true;
        do-ip6 = true;
        prefer-ip6 = false;
        edns-buffer-size = 1232;
        unwanted-reply-threshold = 10000;

        root-hints = "${pkgs.dns-root-data}/root.hints";

        # DNSSEC
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

        # PRIVACIDADE
        qname-minimisation = true;
        minimal-responses = true;
        hide-identity = true;
        hide-version = true;
        hide-trustanchor = true;
        use-caps-for-id = true;
        do-not-query-localhost = false;
        tls-cert-bundle = "/etc/ssl/certs/ca-certificates.crt";

        tls-ciphers =
          "ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305";

        tls-use-sni = true;
        verbosity = 1;
        harden-large-queries = true;
      };

      # Conecta o backend ao seu redis.sock
      cachedb = {
        backend = "redis";
        secret-seed = "darkflake-dns-crypto-seed-ram"; 
        redis-server-path = "/run/redis-meu-banco/redis.sock";
        redis-timeout = 100;
      };

      # Encaminhamento TLS dos TLDs
      forward-zone = [
        {
          name = "com.";
          forward-tls-upstream = "yes";
          forward-addr = [
            "9.9.9.9@853#dns.quad9.net"
            "1.1.1.1@853#cloudflare-dns.com"
          ];
        }
        {
          name = "org.";
          forward-tls-upstream = "yes";
          forward-addr = [
            "9.9.9.9@853#dns.quad9.net"
            "1.1.1.1@853#cloudflare-dns.com"
          ];
        }
        {
          name = "br.";
          forward-tls-upstream = "yes";
          forward-addr = [
            "9.9.9.9@853#dns.quad9.net"
            "1.1.1.1@853#cloudflare-dns.com"
          ];
        }
        {
          name = "net.";
          forward-tls-upstream = "yes";
          forward-addr = [
            "9.9.9.9@853#dns.quad9.net"
            "1.1.1.1@853#cloudflare-dns.com"
          ];
        }
      ];
    };
  };
}

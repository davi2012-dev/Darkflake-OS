{ config, pkgs, lib, ... }:

let
  domains = [
    "nextcloud.darkflake.local"
    "jellyfin.darkflake.local"
    "librechat.darkflake.local"
    "homarr.darkflake.local"
    "stirling.darkflake.local"
    "chat.darkflake.local"
    "metube.darkflake.local"
    "netdata.darkflake.local"
    "ha.darkflake.local"
    "portainer.darkflake.local"
    "search.darkflake.local"
    "cockpit.darkflake.local"
  ];

  # --- GERA OS CERTIFICADOS DURANTE O BUILD (nixos-rebuild) ---
  certs = pkgs.runCommand "caddy-local-certs" {
    buildInputs = [ pkgs.openssl ];
  } ''
    mkdir -p $out

    # 1. Cria a Autoridade Certificadora (CA) local
    openssl genrsa -out $out/ca.key 2048
    openssl req -x509 -new -nodes -key $out/ca.key -sha256 -days 3650 -out $out/ca.crt -subj "/CN=Darkflake Local CA"

    # 2. Cria a chave do servidor (coringa para todos os subdomínios)
    openssl genrsa -out $out/server.key 2048
    openssl req -new -key $out/server.key -out $out/server.csr -subj "/CN=*.darkflake.local"

    # 3. Configura o SAN (obrigatório para navegadores modernos)
    echo "subjectAltName=DNS:*.darkflake.local" > $out/san.cnf

    # 4. Assina o certificado do servidor com a CA local
    openssl x509 -req -in $out/server.csr -CA $out/ca.crt -CAkey $out/ca.key -CAcreateserial -out $out/server.crt -days 3650 -sha256 -extfile $out/san.cnf

    # Limpeza
    rm $out/server.csr $out/san.cnf $out/ca.srl
  '';

  caCert = "${certs}/ca.crt";
  serverCert = "${certs}/server.crt";
  serverKey = "${certs}/server.key";
in
{
  # --- INSTALA A CA NO SISTEMA (curl, wget, Chromium, etc. confiam) ---
  security.pki.certificateFiles = [ caCert ];

  # --- CONFIGURA O FIREFOX PARA USAR OS CERTIFICADOS DO SISTEMA ---
  programs.firefox = {
    enable = true;
    policies = {
      EnableEnterpriseRoots = true; # Firefox passa a confiar na CA do sistema
    };
  };

  # --- CADDY USANDO OS CERTIFICADOS GERADOS NO BUILD ---
  services.caddy = {
    enable = true;
    email = "DaviMigue@proton.me"; # opcional

    virtualHosts = {
      "nextcloud.darkflake.local" = {
        extraConfig = ''
          tls ${serverCert} ${serverKey}
          reverse_proxy localhost:8085
        '';
      };
      "jellyfin.darkflake.local" = {
        extraConfig = ''
          tls ${serverCert} ${serverKey}
          reverse_proxy localhost:8096
        '';
      };
      "search.darkflake.local" = {
        extraConfig = ''
          tls ${serverCert} ${serverKey}
          reverse_proxy localhost:8080
        '';
      };
      "librechat.darkflake.local" = {
        extraConfig = ''
          tls ${serverCert} ${serverKey}
          reverse_proxy localhost:3080
        '';
      };
      "cockpit.darkflake.local" = {
        extraConfig = ''
         tls ${serverCert} ${serverKey}
         reverse_proxy localhost:9090 {
         transport http {
         tls_insecure_skip_verify
      }
    }
  '';
};
      "homarr.darkflake.local" = {
        extraConfig = ''
          tls ${serverCert} ${serverKey}
          reverse_proxy localhost:8083
        '';
      };
      "stirling.darkflake.local" = {
        extraConfig = ''
          tls ${serverCert} ${serverKey}
          reverse_proxy localhost:8089
        '';
      };
      "chat.darkflake.local" = {
        extraConfig = ''
          tls ${serverCert} ${serverKey}
          reverse_proxy localhost:7000
        '';
      };
      "metube.darkflake.local" = {
        extraConfig = ''
          tls ${serverCert} ${serverKey}
          reverse_proxy localhost:8081
        '';
      };
      "netdata.darkflake.local" = {
        extraConfig = ''
          tls ${serverCert} ${serverKey}
          reverse_proxy localhost:19999
        '';
      };
      "ha.darkflake.local" = {
        extraConfig = ''
          tls ${serverCert} ${serverKey}
          reverse_proxy localhost:8123
        '';
      };
      "portainer.darkflake.local" = {
        extraConfig = ''
          tls ${serverCert} ${serverKey}
          reverse_proxy localhost:9443 {
            transport http {
              tls_insecure_skip_verify
            }
          }
        '';
      };
    };
  };

  # --- ENDURECIMENTO (opcional, mas mantido) ---
  systemd.services.caddy.serviceConfig = {
    ProtectSystem = "strict";
    ProtectHome = true;
    PrivateTmp = true;
    ProtectControlGroups = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    NoNewPrivileges = true;
    CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
    AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    MemoryDenyWriteExecute = true;
    SystemCallArchitectures = "native";
    SystemCallFilter = [ "@system-service" "~@privileged" "~@resources" ];
  };
}

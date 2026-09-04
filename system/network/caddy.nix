{ config, pkgs, lib, ... }:
{
  security.pki.certificateFiles = lib.optional (builtins.pathExists ./caddy-ca.crt) ./caddy-ca.crt;

  services.caddy = {
    enable = true;

    virtualHosts = {
      "adguard.darkflake.local".extraConfig = ''
        tls internal
        reverse_proxy localhost:3000
      '';
      "nextcloud.darkflake.local".extraConfig = ''
        tls internal
        reverse_proxy localhost:8085
      '';
      "jellyfin.darkflake.local".extraConfig = ''
        tls internal
        reverse_proxy localhost:8096
      '';
      "search.darkflake.local".extraConfig = ''
        tls internal
        reverse_proxy localhost:8080
      '';
      "librechat.darkflake.local".extraConfig = ''
        tls internal
        reverse_proxy localhost:3080
      '';
      "cockpit.darkflake.local".extraConfig = ''
        tls internal
        reverse_proxy localhost:9090 {
          transport http {
            tls_insecure_skip_verify
          }
        }
      '';
      "homarr.darkflake.local".extraConfig = ''
        tls internal
        reverse_proxy localhost:8083
      '';
      "stirling.darkflake.local".extraConfig = ''
        tls internal
        reverse_proxy localhost:8089
      '';
      "chat.darkflake.local".extraConfig = ''
        tls internal
        reverse_proxy localhost:7000
      '';
      "metube.darkflake.local".extraConfig = ''
        tls internal
        reverse_proxy localhost:8081
      '';
      "netdata.darkflake.local".extraConfig = ''
        tls internal
        reverse_proxy localhost:19999
      '';
      "ha.darkflake.local".extraConfig = ''
        tls internal
        reverse_proxy localhost:8123
      '';
      "portainer.darkflake.local".extraConfig = ''
        tls internal
        reverse_proxy localhost:9443 {
          transport http {
            tls_insecure_skip_verify
          }
        }
      '';
    };
  };

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

  systemd.services.caddy-trust-autosync = {
    description = "Copia a CA local do Caddy pro flake e reconstroi o sistema uma vez, pra confiar nela automaticamente";
    after = [ "caddy.service" "network-online.target" ];
    wants = [ "caddy.service" "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    unitConfig.ConditionPathExists = "!/etc/nixos/caddy-ca.crt";
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      TimeoutStartSec = "600";
    };
    script = ''
      set -e
      CERT_SRC=/var/lib/caddy/.local/share/caddy/pki/authorities/local/root.crt
      CERT_DST=/etc/nixos/caddy-ca.crt

      for i in $(seq 1 60); do
        if [ -f "$CERT_SRC" ]; then
          break
        fi
        sleep 5
      done

      if [ ! -f "$CERT_SRC" ]; then
        echo "Caddy nao gerou a CA a tempo (5min), abortando sem reconstruir" >&2
        exit 1
      fi

      cp "$CERT_SRC" "$CERT_DST"
      chmod 644 "$CERT_DST"

      /run/current-system/sw/bin/nixos-rebuild switch --flake /etc/nixos#Darkflake
    '';
  };
}

{ config, pkgs, lib, ... }:
{
  systemd.services.searx-secret-init = {
    description = "Gera o secret_key do SearXNG na primeira ativação, se ainda não existir";
    wantedBy = [ "searx.service" ];
    before = [ "searx.service" ];
    unitConfig.ConditionPathExists = "!/var/lib/searx/secret.env";
    serviceConfig = {
      Type = "oneshot";
      User = "searx";
      Group = "searx";
    };
    script = ''
      umask 077
      echo "SEARXNG_SECRET=$(${pkgs.openssl}/bin/openssl rand -hex 64)" > /var/lib/searx/secret.env
    '';
  };

  services.searx = {
    enable = true;
    package = pkgs.searxng;
    redisCreateLocally = true;
    environmentFile = "/var/lib/searx/secret.env";
    settings = {
      server = {
        port = 8080;
        bind_address = "127.0.0.1";
      };
      ui = {
        default_theme = "simple";
        theme_args.simple_style = "auto";
        no_cookies = true;
        hotkeys = "default";
      };
      search = {
        autocomplete = "duckduckgo";
        safe_search = 0;
      };
    };
  };

  systemd.services.searx.serviceConfig = {
    ReadWritePaths = [
      "/var/log/searx"
      "/var/cache/searx"
      "/var/lib/searx"
      "/run/searx"
    ];
    ProtectSystem = "strict";
    ProtectHome = "read-only";
    PrivateTmp = true;
    ProtectControlGroups = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    ProtectKernelLogs = true;
    ProtectHostname = true;
    ProtectClock = true;
    PrivateIPC = true;
    LockPersonality = true;
    NoNewPrivileges = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    RestrictNamespaces = true;
    MemoryDenyWriteExecute = true;
    RemoveIPC = true;
    UMask = "0077";
    CapabilityBoundingSet = [ ];
    AmbientCapabilities = [ ];
    RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
    SystemCallArchitectures = "native";
    SystemCallFilter = [ "@system-service" "~@resources" ];
    Restart = "on-failure";
    RestartSec = "10s";
  };

  systemd.tmpfiles.rules = [
    "d /var/log/searx 0755 searx searx -"
    "d /var/cache/searx 0755 searx searx -"
    "d /var/lib/searx 0755 searx searx -"
    "d /run/searx 0755 searx searx -"
  ];
}

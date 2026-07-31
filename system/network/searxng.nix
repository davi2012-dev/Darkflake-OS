{ config, pkgs, lib, ... }:
let
  # --- GERA O SECRET_KEY DURANTE O BUILD (nixos-rebuild) ---
  secretKeyFile = pkgs.runCommand "searx-secret-key" {
    buildInputs = [ pkgs.openssl ];
  } ''
    openssl rand -hex 64 > $out
  '';
  secretKey = lib.removeSuffix "\n" (builtins.readFile secretKeyFile);
in
{
  # --- (SearXNG) ---
  services.searx = {
    enable = true;
    package = pkgs.searxng;
    redisCreateLocally = true;
    settings = {
      server = {
        port = 8080;
        bind_address = "127.0.0.1";
        secret_key = secretKey;
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
      engines = [
        { name = "google"; engine = "google"; shortcut = "g"; }
        { name = "duckduckgo"; engine = "duckduckgo"; shortcut = "d"; }
        { name = "wikipedia"; engine = "wikipedia"; shortcut = "w"; }
      ];
    };
  };

  # --- HARDENING VIA SYSTEMD ---
  systemd.services.searx.serviceConfig = {
    ReadWritePaths = [
      "/var/log/searx"
      "/var/cache/searx"
      "/var/lib/searx"
      "/tmp"
      "/run/searx"
    ];

    ProtectSystem = "full";
    ProtectHome = "read-only";
    PrivateTmp = "yes";
    ProtectControlGroups = "yes";
    ProtectKernelModules = "yes";
    ProtectKernelTunables = "yes";
    NoNewPrivileges = "yes";
    RestrictRealtime = "yes";
    RestrictSUIDSGID = "yes";
    RestrictNamespaces = "yes";
    MemoryDenyWriteExecute = "yes";
    CapabilityBoundingSet = [ ];
    AmbientCapabilities = [ ];

    SystemCallArchitectures = "native";
    SystemCallFilter = [
      "@system-service"
      "~@resources"
    ];
    Restart = "on-failure";
    RestartSec = "10s";
  };

  # --- CRIA OS DIRETÓRIOS NECESSÁRIOS ---
  systemd.tmpfiles.rules = [
    "d /var/log/searx 0755 searx searx -"
    "d /var/cache/searx 0755 searx searx -"
    "d /var/lib/searx 0755 searx searx -"
    "d /run/searx 0755 searx searx -"
  ];
}

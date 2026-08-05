{ config, pkgs, lib, ... }:

let
  cockpitService = "cockpit.service";
in {
  services.cockpit = {
    enable = true;
    settings = {
      WebService = {
        AllowUnencrypted = false;
        Origins = lib.mkForce "https://localhost:9090 https://127.0.0.1:9090 https://cockpit.darkflake.local";
      };
    };
  };

  # --- HARDENING  ---
  systemd.services.${cockpitService}.serviceConfig = {
    ReadWritePaths = [
      "/var/log/cockpit"
      "/var/lib/cockpit"
      "/var/cache/cockpit"
      "/tmp"
      "/run/cockpit"
      "/var/run/libvirt"
    ];

    ProtectSystem = "full";
    ProtectHome = "read-only";
    PrivateTmp = "yes";
    ProtectControlGroups = "yes";
    ProtectKernelModules = "yes";
    ProtectKernelTunables = "yes";
    RestrictRealtime = "yes";
    RestrictSUIDSGID = "yes";
    RestrictNamespaces = "yes";
    MemoryDenyWriteExecute = "yes";
    CapabilityBoundingSet = [
      "CAP_SYS_ADMIN"
      "CAP_DAC_READ_SEARCH"
      "CAP_NET_ADMIN"
      "CAP_SYSLOG"
    ];

    SystemCallArchitectures = "native";
    SystemCallFilter = [
      "@system-service"
      "~@resources"       
    ];

    Restart = "on-failure";
    RestartSec = "10s";
  };

  # --- CRIA OS DIRETÓRIOS ---
  systemd.tmpfiles.rules = [
    "d /var/log/cockpit 0750 cockpit-ws cockpit-ws -"
    "d /var/lib/cockpit 0750 cockpit-ws cockpit-ws -"
    "d /var/cache/cockpit 0750 cockpit-ws cockpit-ws -"
    "d /run/cockpit 0755 root root -"    
  ];
}

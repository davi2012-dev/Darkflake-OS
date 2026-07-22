{ config, pkgs, lib, ... }: {

  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
    updater.interval = "12h";

    daemon.settings = {

      OnAccessMaxFileSize = "150M";
      OnAccessIncludePath = [ "/home/davi" "/tmp" "/var/tmp" ];
      OnAccessExcludePath = [ "/proc" "/sys" "/dev" "/run" "/nix/store" ];
      OnAccessPrevention = true;
      OnAccessExtraScanning = true;

      DetectPUA = true;
      HeuristicAlerts = true;
      HeuristicScanPrecedence = true;
      StructuredDataDetection = true;
      Bytecode = true;
      BytecodeSecurity = "TrustSigned";
      
      MaxScanSize = "400M";
      MaxFileSize = "200M";
      AlertBrokenExecutables = true;
      AlertEncrypted = false;

      LogFile = "/var/log/clamav/clamd.log";
      LogVerbose = true;
      LogSyslog = true;
    };
  };

  # --- HARDENING ---
  systemd.services.clamav-daemon = {
  serviceConfig = {

    User = lib.mkForce "clamav";
    Group = lib.mkForce "clamav";

    # PERMISSÕES CAP
    CapabilityBoundingSet = [ "CAP_SYS_ADMIN" "CAP_IPC_LOCK" ];
    AmbientCapabilities = [ "CAP_SYS_ADMIN" "CAP_IPC_LOCK" ];

    # PRIORIDADE (mantida)
    CPUSchedulingPolicy = "fifo";
    CPUSchedulingPriority = 60;
    IOSchedulingClass = "realtime";
    IOSchedulingPriority = 0;
    OOMScoreAdjust = 50;
    Restart = "always";
    RestartSec = "1s";

    # PERMISSÕES DE ESCRITA (mantidas)
    ReadWritePaths = [
      "/var/lib/clamav"
      "/var/log/clamav"
      "/tmp"
      "/var/tmp"
      "/run/clamav"
      "/var/run/clamav"
    ];

    # ISOLAMENTO (mantido)
    ProtectSystem = "full";
    ProtectHome = "read-only";
    PrivateTmp = lib.mkForce "yes";
    ProtectControlGroups = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    NoNewPrivileges = false;  
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    RestrictNamespaces = true;
    MemoryDenyWriteExecute = false;

    SystemCallArchitectures = "native";
    SystemCallFilter = [ "@system-service" "~@resources" ];
  };
 };

  # --- CRIA AS PASTAS DE LOG E ASSINATURA COM PERMISSÕES CERTAS ---
  systemd.tmpfiles.rules = [
    "d /var/lib/clamav 0750 clamav clamav -"
    "d /var/log/clamav 0750 clamav clamav -"
  ];

  environment.systemPackages = with pkgs; [ clamav ];
}

{ config, pkgs, lib, ... }:

let
  cockpitService = "cockpit.service";  # Ou "cockpit-ws.service"
in {
  services.cockpit = {
    enable = true;
    settings = {
      WebService = {
        AllowUnencrypted = false;
        Origins = lib.mkForce "https://localhost:9090 https://127.0.0.1:9090";
      };
    };
  };

  # --- HARDENING AJUSTADO (SEM BLOQUEIOS QUE QUEBRAM) ---
  systemd.services.${cockpitService}.serviceConfig = {
    # 1. DIRETÓRIOS ONDE O COCKPIT PODE ESCREVER
    ReadWritePaths = [
      "/var/log/cockpit"
      "/var/lib/cockpit"
      "/var/cache/cockpit"
      "/tmp"
      "/run/cockpit"        # <-- ADICIONADO (sockets)
    ];

    # 2. SISTEMA DE ARQUIVOS (MANTIDO)
    ProtectSystem = "full";
    ProtectHome = "read-only";
    PrivateTmp = "yes";
    ProtectControlGroups = "yes";
    ProtectKernelModules = "yes";
    ProtectKernelTunables = "yes";

    # 3. PRIVILÉGIOS (AJUSTADO PARA NÃO QUEBRAR)
    # REMOVA NoNewPrivileges (ou desative) – o Cockpit precisa de setuid para sudo/pkexec
    # NoNewPrivileges = false;   # <-- DESCOMENTE SE PRECISAR, MAS O PADRÃO É false

    RestrictRealtime = "yes";
    RestrictSUIDSGID = "yes";
    RestrictNamespaces = "yes";
    MemoryDenyWriteExecute = "yes";

    # 4. CAPABILITIES (MANTIDAS)
    CapabilityBoundingSet = [
      "CAP_SYS_ADMIN"
      "CAP_DAC_READ_SEARCH"
      "CAP_NET_ADMIN"
      "CAP_SYSLOG"
    ];

    # 5. SYSCALLS (SEM BLOQUEIO DE setuid)
    SystemCallArchitectures = "native";
    SystemCallFilter = [
      "@system-service"
      "~@resources"        # BLOQUEIA APENAS ioperm, iopl, etc. (NÃO BLOQUEIA setuid)
    ];

    # 6. REINÍCIO AUTOMÁTICO
    Restart = "on-failure";
    RestartSec = "10s";
  };

  # --- CRIA OS DIRETÓRIOS ---
  systemd.tmpfiles.rules = [
    "d /var/log/cockpit 0750 cockpit-ws cockpit-ws -"
    "d /var/lib/cockpit 0750 cockpit-ws cockpit-ws -"
    "d /var/cache/cockpit 0750 cockpit-ws cockpit-ws -"
    "d /run/cockpit 0755 root root -"          # <-- ADICIONADO
  ];
}

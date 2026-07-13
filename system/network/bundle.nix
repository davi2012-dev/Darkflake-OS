{ config, pkgs, ... }: {

  imports = [
    ./ssh.nix
    ./dns.nix
    ./samba.nix
    ./cockpit.nix
    ./firewall.nix
    ./analysis.nix
    ./Adguard.nix
    ./searxng.nix
    ./caddy.nix
    ./dnscrypt-proxy.nix
  ];

  networking.hostName = "Darkflake";
  networking.stevenblack.enable = true;
  networking.tempAddresses = "default";
  networking.nameservers = [
    "127.0.0.1"
    "::1"
  ];
  networking.networkmanager.dns = "none";
  networking.resolvconf.enable = false;
  services.resolved.enable = false;

  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
    wifi.scanRandMacAddress = true;
    wifi.macAddress = "random";
    ethernet.macAddress = "random";
  };

  services.timesyncd.enable = false;

  services.chrony = {
    enable = true;
    servers = [
      "time.cloudflare.com iburst nts"
      "nts.netnod.se iburst nts"
      "nts.ekspresso.se iburst nts"
    ];
    extraConfig = ''
      authselectmode require
    '';
  };

  # ===== HARDENING PARA CHRONY (TODAS AS OPÇÕES QUE JÁ ESTÃO ATIVAS) =====
  systemd.services.chronyd = {
    serviceConfig = {
      # System Call Filtering
      SystemCallFilter = [
        "~@swap"
        "~@resources"
        "~@reboot"
        "~@raw-io"
        "~@obsolete"
        "~@mount"
        "~@module"
        "~@debug"
        "~@cpu-emulation"
      ];

      # Proteção de sistema
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
      PrivateMounts = true;
      ProtectProc = "invisible";
      ProcSubset = "all";
      PrivateIPC = true;
      LockPersonality = true;

      # Proteção de kernel
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      ProtectKernelTunables = true;
      ProtectControlGroups = true;
      ProtectHostname = true;

      # Proteção de memória e processos
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      RestrictNamespaces = true;

      # Restrições de rede
      RestrictAddressFamilies = [
        "AF_INET"
        "AF_INET6"
        "AF_UNIX"
      ];

      # Chamadas de sistema
      SystemCallArchitectures = "native";

      # Capacidades (mínimo necessário)
      CapabilityBoundingSet = [
        "CAP_SYS_TIME"
        "CAP_NET_BIND_SERVICE"
      ];

      # Outras proteções
      PrivateDevices = true;
      RemoveIPC = true;
      UMask = "0077";

    };
  };

  # ===== HARDENING PARA NETWORKMANAGER =====
  systemd.services.NetworkManager = {
    serviceConfig = {
      User = "";
      NoNewPrivileges = true;
      PrivateDevices = true;
      ProtectClock = true;
      CapabilityBoundingSet = [ ];
      ProtectKernelLogs = true;
      ProtectControlGroups = true;
      ProtectKernelModules = false;
      SystemCallArchitectures = "native";
      MemoryDenyWriteExecute = true;
      RestrictNamespaces = true;
      RestrictSUIDSGID = true;
      ProtectHostname = true;
      LockPersonality = true;
      ProtectKernelTunables = false;
      RestrictAddressFamilies = [ ];
      RestrictRealtime = true;
      ProtectHome = true;
      DeviceAllow = "";
      ProtectSystem = false;
      ProtectProc = true;
      ProcSubset = true;
      PrivateNetwork = false;
      PrivateUsers = false;
      PrivateTmp = true;
      SystemCallFilter = [ ];
      IPAddressDeny = "";
      UMask = "0077";
    };
  };
}

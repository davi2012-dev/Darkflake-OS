{ config, pkgs, lib, ... }: {

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

  # ===== HARDENING PARA CHRONY =====
  systemd.services.chronyd = {
    serviceConfig = {
      SystemCallFilter = lib.mkForce [
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

      ProtectSystem = lib.mkForce "full";
      ProtectHome = lib.mkForce true;
      PrivateTmp = lib.mkForce true;
      PrivateMounts = lib.mkForce true;
      ProtectProc = lib.mkForce "invisible";
      ProcSubset = lib.mkForce "pid";
      PrivateIPC = lib.mkForce true;
      LockPersonality = lib.mkForce true;

      ProtectKernelModules = lib.mkForce true;
      ProtectKernelLogs = lib.mkForce true;
      ProtectKernelTunables = lib.mkForce true;
      ProtectControlGroups = lib.mkForce true;
      ProtectHostname = lib.mkForce true;

      MemoryDenyWriteExecute = lib.mkForce true;
      NoNewPrivileges = lib.mkForce true;
      RestrictRealtime = lib.mkForce true;
      RestrictSUIDSGID = lib.mkForce true;
      RestrictNamespaces = lib.mkForce true;

      RestrictAddressFamilies = lib.mkForce [
        "AF_INET"
        "AF_INET6"
        "AF_UNIX"
      ];

      SystemCallArchitectures = lib.mkForce "native";

      CapabilityBoundingSet = lib.mkForce [
        "CAP_SYS_TIME"
        "CAP_NET_BIND_SERVICE"
      ];

      RemoveIPC = lib.mkForce true;
      UMask = lib.mkForce "0077";
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

{
  config,
  pkgs,
  lib,
  ...
}:
{

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
    enableNTS = true;
    enableRTCTrimming = true;
    autotrimThreshold = 30;
    enableMemoryLocking = true;

    makestep = {
      enable = true;
      threshold = 1.0;
      limit = 3;
    };

    servers = [
      "time.cloudflare.com iburst nts"
      "nts.netnod.se iburst nts"
      "nts.ekspresso.se iburst nts"
      "ptbtime1.ptb.de iburst nts"
      "nts.ntp.se iburst nts"
      "virginia.time.system76.com iburst nts"
      "ohio.time.system76.com iburst nts"
      "oregon.time.system76.com iburst nts"
      "paris.time.system76.com iburst nts"
      "brazil.time.system76.com iburst nts"
    ];

    extraConfig = ''
      authselectmode require
      ntsrefresh 3600
      maxsamples 8
      minsources 3
      maxsources 6
      minpoll 6
      maxpoll 9
      logchange 0.5
      maxupdateskew 100.0
      ntsdumpdir /var/lib/chrony
    '';
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

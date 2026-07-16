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
  networking.domain = "local";
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
      "time.cloudflare.com iburst nts minpoll 6 maxpoll 9"
      "nts.netnod.se iburst nts minpoll 6 maxpoll 9"
      "nts.ekspresso.se iburst nts minpoll 6 maxpoll 9"
      "ptbtime1.ptb.de iburst nts minpoll 6 maxpoll 9"
      "nts.ntp.se iburst nts minpoll 6 maxpoll 9"
      "virginia.time.system76.com iburst nts minpoll 6 maxpoll 9"
      "ohio.time.system76.com iburst nts minpoll 6 maxpoll 9"
      "oregon.time.system76.com iburst nts minpoll 6 maxpoll 9"
      "paris.time.system76.com iburst nts minpoll 6 maxpoll 9"
      "brazil.time.system76.com iburst nts minpoll 6 maxpoll 9"
    ];

    extraConfig = ''
      authselectmode require
      ntsrefresh 3600
      maxsamples 8
      minsources 3
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

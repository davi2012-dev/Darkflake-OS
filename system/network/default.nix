{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./ssh.nix
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
    ethernet.macAddress = "stable";
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
      # ===== Brasil  =====
      "a.st1.ntp.br iburst nts minpoll 6 maxpoll 9"
      "b.st1.ntp.br iburst nts minpoll 6 maxpoll 9"
      "c.st1.ntp.br iburst nts minpoll 6 maxpoll 9"
      "d.st1.ntp.br iburst nts minpoll 6 maxpoll 9"
      "gps.ntp.br iburst nts minpoll 6 maxpoll 9"
      "brazil.time.system76.com iburst nts minpoll 6 maxpoll 9"
      "time.bolha.one iburst nts minpoll 6 maxpoll 9"
      # ===== Europa =====
      "time.cloudflare.com iburst nts minpoll 6 maxpoll 9"
      "nts.netnod.se iburst nts minpoll 6 maxpoll 9"
      "gbg1.nts.netnod.se iburst nts minpoll 6 maxpoll 9"
      "sth1.nts.netnod.se iburst nts minpoll 6 maxpoll 9"
      "lul1.nts.netnod.se iburst nts minpoll 6 maxpoll 9"    
      "mmo1.nts.netnod.se iburst nts minpoll 6 maxpoll 9"     
      "ptbtime1.ptb.de iburst nts minpoll 6 maxpoll 9"
      "ptbtime2.ptb.de iburst nts minpoll 6 maxpoll 9"
      "ptbtime3.ptb.de iburst nts minpoll 6 maxpoll 9"          
      "ptbtime4.ptb.de iburst nts minpoll 6 maxpoll 9"       
      "ntp3.fau.de iburst nts minpoll 6 maxpoll 9"
      "1.nts.nothingtohide.nl iburst nts minpoll 6 maxpoll 9"
      "2.nts.nothingtohide.nl iburst nts minpoll 6 maxpoll 9"  
      "ntppool1.time.nl iburst nts minpoll 6 maxpoll 9"
      "ntppool2.time.nl iburst nts minpoll 6 maxpoll 9"     
      "ntp0.cam.ac.uk iburst nts minpoll 6 maxpoll 9"
      "ntp1.cam.ac.uk iburst nts minpoll 6 maxpoll 9"           
      "nts1.ntp.hr iburst nts minpoll 6 maxpoll 9"           
      "time.cincura.net iburst nts minpoll 6 maxpoll 9"       
      "nts.teambelgium.net iburst nts minpoll 6 maxpoll 9"    
      "ntp1.dmz.terryburton.co.uk iburst nts minpoll 6 maxpoll 9" 
      "paris.time.system76.com iburst nts minpoll 6 maxpoll 9" 
      # ===== América do Norte =====
      "virginia.time.system76.com iburst nts minpoll 6 maxpoll 9"
      "oregon.time.system76.com iburst nts minpoll 6 maxpoll 9"
      "ohio.time.system76.com iburst nts minpoll 6 maxpoll 9"   
      "ntp1.wiktel.com iburst nts minpoll 6 maxpoll 9"         
      "time1.mbix.ca iburst nts minpoll 6 maxpoll 9"            
      "time2.mbix.ca iburst nts minpoll 6 maxpoll 9"
      # ===== Ásia =====
      "ntpmon.dcs1.biz iburst nts minpoll 6 maxpoll 9"
    ];
    extraConfig = ''
      authselectmode require
      ntsrefresh 3600
      ntsrotate 604800
      ntsdumpdir /var/lib/chrony
      maxsamples 8
      minsources 4
      logchange 0.5
      maxupdateskew 100.0
      maxdistance 1.0
      maxjitter 0.5
      corrtimeratio 3.0
      leapsectz right/UTC
      dumponexit
      maxdrift 500
      stratumweight 0
      rtcsync
      dumpdir /var/lib/chrony
      cmdport 0
      clientloglimit 0 
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

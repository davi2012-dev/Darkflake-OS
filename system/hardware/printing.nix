{ config, pkgs, ... }: {

  systemd.tmpfiles.rules = [
    "d /var/spool/cups 1777 root root -"
  ];

  services.printing = {
    enable = true;
    drivers = with pkgs; [ 
      gutenprint gutenprintBin hplip hplipWithPlugin
      brlaser brgenml1lpr canon-cups-ufr2 epson-escpr splix foo2zjs
    ];
    browsing = false;
    defaultShared = false;
    webInterface = false;
    startWhenNeeded = true;
    openFirewall = false;
  };

  systemd.services.cups = {
    overrideStrategy = "asDropin";
    serviceConfig = {
      DynamicUser = true;
      StateDirectory = "cups";
      RuntimeDirectory = "cups";
      CacheDirectory = "cups";
      LogsDirectory = "cups";
      ReadWritePaths = [ "/var/spool/cups" "/tmp" ];

      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
      ProtectControlGroups = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      NoNewPrivileges = true;

      CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" "CAP_DAC_OVERRIDE" ];
      AmbientCapabilities = [ ];

      RestrictNamespaces = "~user pid net uts cgroup ipc";
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      MemoryDenyWriteExecute = true;
      SystemCallArchitectures = "native";

      DeviceAllow = [
        "char-lp rw"
        "char-usb/lp rw"
        "/dev/bus/usb rw"
      ];
      DevicePolicy = "closed";

      RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" "AF_NETLINK" ];
      PrivateNetwork = false;

      SystemCallFilter = [
        "~@raw-io" "~@clock" "~@reboot"
        "~@swap" "~@mount" "~@module"
      ];
    };
  };


  # ======== AVADHI ========
  services.avahi = {
    enable = true;
    domainName = "local";
    allowInterfaces = [ "wlan0" ];
    nssmdns4 = true;
    nssmdns6 = true;
    reflector = false;
    publish.hinfo = false;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };

  # ======== Sane (scanners) ========
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.hplipWithPlugin ];
  };
}

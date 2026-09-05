{ config, pkgs, ... }: {
  systemd.tmpfiles.rules = [
    "d /var/spool/cups 1777 root root -"
  ];

  services.printing = {
    enable = true;
    drivers = [ ];
    browsing = false;
    browsed.enable = false;
    defaultShared = false;
    webInterface = false;
    startWhenNeeded = true;
    openFirewall = false;
  };

  services.ipp-usb.enable = true;

  hardware.printers = {
    ensureDefaultPrinter = "MinhaImpressora";
    ensurePrinters = [
      {
        name = "MinhaImpressoraUSB";
        location = "Home (USB)";
        deviceUri = "ipp://127.0.0.1:60000/ipp/print";
        model = "everywhere";
      }
      {
        name = "MinhaImpressoraRede";
        location = "Home (rede)";
        deviceUri = "ipp://192.168.1.XX/ipp";
        model = "everywhere";
      }
    ];
  };

  systemd.services.cups.serviceConfig = {
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
    CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
    AmbientCapabilities = [ ];
    RestrictNamespaces = "~user pid net uts cgroup ipc";
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    MemoryDenyWriteExecute = true;
    SystemCallArchitectures = "native";
    DevicePolicy = "closed";
    RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" "AF_NETLINK" ];
    SystemCallFilter = [ "~@raw-io" "~@clock" "~@reboot" "~@swap" "~@mount" "~@module" ];
  };

  systemd.services.ipp-usb.serviceConfig = {
    ProtectSystem = "strict";
    ProtectHome = true;
    PrivateTmp = true;
    ProtectControlGroups = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    NoNewPrivileges = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    MemoryDenyWriteExecute = true;
    SystemCallArchitectures = "native";
    RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
  };

  services.avahi = {
    enable = true;
    domainName = "local";
    allowInterfaces = [ "wlan0" ];
    nssmdns4 = true;
    nssmdns6 = true;
    reflector = false;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };

  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.hplipWithPlugin ];
  };
}

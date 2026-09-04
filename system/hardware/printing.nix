{ config, pkgs, ... }: {
  services.printing = {
    enable = true;
    drivers = [ ];
    browsing = false;
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
        name = "MinhaImpressora";
        location = "Home";
        deviceUri = "ipp://localhost/ipp/print";
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
}

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

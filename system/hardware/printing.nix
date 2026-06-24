{ config, pkgs, ... }: {
  # ======== IMPRESSÃO ========
  services.printing = {
    enable = true;
    drivers = with pkgs; [ 
      gutenprint
      gutenprintBin
      hplip
      hplipWithPlugin
      brlaser
      brgenml1lpr
      canon-cups-ufr2
      epson-escpr
      splix
      foo2zjs
    ];
    # Segurança
    browsing = false;
    defaultShared = false;
    webInterface = false;           # desativa interface web
    startWhenNeeded = true;         # socket activation
    openFirewall = false;           # não abre porta automaticamente
  };

  # Hardening do CUPS
  systemd.services.cups.serviceConfig = {
    ProtectSystem = "strict";
    ReadWritePaths = [ "/var/spool/cups" "/var/log/cups" "/run/cups" "/tmp" ];
    ProtectHome = true;
    PrivateTmp = true;
    ProtectControlGroups = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    NoNewPrivileges = true;
    CapabilityBoundingSet = [ "CAP_SYS_RAWIO" "CAP_NET_BIND_SERVICE" ];
    AmbientCapabilities = [ "CAP_SYS_RAWIO" "CAP_NET_BIND_SERVICE" ];
    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    MemoryDenyWriteExecute = true;
    SystemCallArchitectures = "native";
    SystemCallFilter = [ "@system-service" "~@privileged" "~@resources" ];
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

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
systemd.services.cups = {
  overrideStrategy = "asDropin";
  serviceConfig = {
    # Usuário dinâmico – dispensa User/Group fixos
    DynamicUser = true;

    # Diretórios gerenciados pelo systemd (criam com permissões corretas)
    StateDirectory = "cups";          # /var/lib/cups
    RuntimeDirectory = "cups";        # /run/cups
    CacheDirectory = "cups";          # /var/cache/cups (opcional)
    LogsDirectory = "cups";           # /var/log/cups

    # Caminhos que o serviço pode escrever (além dos gerenciados acima)
    ReadWritePaths = [
      "/var/spool/cups"               # spool de impressão
      "/tmp"                          # temporários (opcional, mas mantido)
    ];

    # Proteções básicas
    ProtectSystem = "strict";
    ProtectHome = true;
    PrivateTmp = true;
    ProtectControlGroups = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    NoNewPrivileges = true;

    # Capacidades (sem CAP_SYS_RAWIO)
    CapabilityBoundingSet = [
      "CAP_NET_BIND_SERVICE"          # porta 631
      "CAP_DAC_OVERRIDE"              # permissões de arquivo (pode ser necessário)
    ];
    AmbientCapabilities = [ ];

    # Namespaces – permite montagem para os diretórios gerenciados
    RestrictNamespaces = "~user pid net uts cgroup ipc";
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    MemoryDenyWriteExecute = true;
    SystemCallArchitectures = "native";

    # Acesso a dispositivos (impressoras)
    DeviceAllow = [
      "char-lp rw"
      "char-usb/lp rw"
      "/dev/bus/usb rw"
    ];
    DevicePolicy = "closed";

    # Rede
    RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" "AF_NETLINK" ];
    PrivateNetwork = false;

    # Filtro de syscalls (bloqueia apenas os realmente perigosos)
    SystemCallFilter = [
      "~@raw-io"
      "~@clock"
      "~@reboot"
      "~@swap"
      "~@mount"
      "~@module"
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

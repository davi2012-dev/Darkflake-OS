{ config, pkgs, lib, ... }:

{
  # --- BUSCADOR PRÓPRIO (SearXNG) ---
  services.searx = {
    enable = true;
    package = pkgs.searxng;
    redisCreateLocally = true;

    settings = {
      server = {
        port = 8080;
        bind_address = "127.0.0.1";
        secret_key = "UmaSenhaSuperSecretaAquiParaOsCookies";
      };

      ui = {
        default_theme = "simple";
        theme_args.simple_style = "auto";
        no_cookies = true;
        hotkeys = "default";
      };

      search = {
        autocomplete = "duckduckgo";
        safe_search = 0;
      };

      engines = [
        { name = "google"; engine = "google"; shortcut = "g"; }
        { name = "duckduckgo"; engine = "duckduckgo"; shortcut = "d"; }
        { name = "wikipedia"; engine = "wikipedia"; shortcut = "w"; }
      ];
    };
  };

  # --- HARDENING VIA SYSTEMD (MESMO PADRÃO DO COCKPIT) ---
  systemd.services.searx.serviceConfig = {
    # DIRETÓRIOS ONDE O SEARXNG PODE ESCREVER
    ReadWritePaths = [
      "/var/log/searx"          # Logs
      "/var/cache/searx"        # Cache de buscas/resultados
      "/var/lib/searx"          # Dados persistentes (se houver)
      "/tmp"                    # Arquivos temporários
      "/run/searx"              # Socket (se usar)
    ];

    # SISTEMA DE ARQUIVOS (LEITURA QUASE TOTAL, ESCRITA CONTROLADA)
    ProtectSystem = "full";
    ProtectHome = "read-only";
    PrivateTmp = "yes";
    ProtectControlGroups = "yes";
    ProtectKernelModules = "yes";
    ProtectKernelTunables = "yes";

    # SANDBOX DE PRIVILÉGIOS
    # O SearXNG não precisa de setuid, então podemos ativar tudo
    NoNewPrivileges = "yes";
    RestrictRealtime = "yes";
    RestrictSUIDSGID = "yes";
    RestrictNamespaces = "yes";
    MemoryDenyWriteExecute = "yes";

    # CAPABILITIES (nenhuma necessária – ele só escuta porta >1024)
    CapabilityBoundingSet = [ ];
    AmbientCapabilities = [ ];

    # FILTRO DE SYSCALLS (SEM BLOQUEIO DE setuid)
    SystemCallArchitectures = "native";
    SystemCallFilter = [
      "@system-service"
      "~@resources"           # Bloqueia ioperm, iopl, etc.
    ];

    # REINÍCIO AUTOMÁTICO
    Restart = "on-failure";
    RestartSec = "10s";
  };

  # --- CRIA OS DIRETÓRIOS NECESSÁRIOS ---
  systemd.tmpfiles.rules = [
    "d /var/log/searx 0755 searx searx -"
    "d /var/cache/searx 0755 searx searx -"
    "d /var/lib/searx 0755 searx searx -"
    "d /run/searx 0755 searx searx -"
  ];

  # --- INSTALA O PACOTE (caso não venha com o módulo) ---
  environment.systemPackages = with pkgs; [ searxng ];
}

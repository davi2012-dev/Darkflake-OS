{ config, pkgs, lib, ... }:

let
  cockpitService = "cockpit.service";  # Ou "cockpit-ws.service", depende da versão
in {
  services.cockpit = {
    enable = true;
    settings = {
      WebService = {
        AllowUnencrypted = false;
        Origins = lib.mkForce "https://localhost:9090 https://127.0.0.1:9090";
      };
    };
  };

  # --- HARDENING PROFUNDO VIA SYSTEMD (IGUAL AO SSH/SAMBA/CLAMAV) ---
  systemd.services.${cockpitService}.serviceConfig = {
    # 1. DIRETÓRIOS ONDE O COCKPIT PODE ESCREVER
    ReadWritePaths = [
      "/var/log/cockpit"          # Logs do Cockpit
      "/var/lib/cockpit"          # Dados persistentes (ex: configurações de sessão)
      "/var/cache/cockpit"        # Cache de páginas web/imagens
      "/tmp"                      # Arquivos temporários (uploads, etc)
    ];

    # 2. SISTEMA DE ARQUIVOS: LEITURA QUASE TOTAL, ESCRITA CONTROLADA
    # O Cockpit precisa LER tudo (logs, systemd, configurações), mas não precisa ESCREVER fora das pastas acima.
    ProtectSystem = "full";           # /usr, /boot, /etc ficam apenas leitura
    ProtectHome = "read-only";        # Pode ler /home (para mostrar contas de usuário), mas não gravar
    PrivateTmp = true;                # Isola /tmp do Cockpit
    ProtectControlGroups = true;      # Bloqueia cgroups
    ProtectKernelModules = true;      # Impede carregar módulos
    ProtectKernelTunables = true;     # Impede alterar parâmetros do kernel (/proc/sys)

    # 3. PRIVILÉGIOS E SANDBOX
    NoNewPrivileges = true;           # Impede escalada de privilégios
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    RestrictNamespaces = true;        # Impede criar novos namespaces (ex: montar sistemas de arquivos)
    MemoryDenyWriteExecute = true;    # Proteção extra contra exploração de memória (o Cockpit não precisa de JIT/bytecode, então pode ativar)

    # 4. CAPABILITIES (O mínimo necessário)
    # O Cockpit precisa de CAP_SYS_ADMIN para ler logs do kernel, CAP_DAC_READ_SEARCH para acessar arquivos protegidos,
    # e CAP_NET_ADMIN para gerenciar rede (se você for usar essa funcionalidade).
    # Vamos dar o mínimo:
    CapabilityBoundingSet = [
      "CAP_SYS_ADMIN"
      "CAP_DAC_READ_SEARCH"
      "CAP_NET_ADMIN"
      "CAP_SYSLOG"
    ];
    AmbientCapabilities = [ ];   # Não precisa de caps ambientes
    # Se quiser mais restrito, remova CAP_NET_ADMIN e perca a funcionalidade de rede no Cockpit.

    # 5. FILTRO DE SYSCALLS (O MESMO USADO NO CLAMAV)
    SystemCallArchitectures = "native";
    SystemCallFilter = [
      "@system-service"
      "~@privileged"          # Bloqueia setuid, setgid, etc.
      "~@resources"           # Bloqueia ioperm, iopl, etc.
    ];

    # 6. PROTEÇÃO ADICIONAL CONTRA EXPLORAÇÃO
    # Impede que o Cockpit crie processos filhos com permissões elevadas (via fork)
    # (já que NoNewPrivileges já faz isso)
    # Não precisa de mais nada.

    # 7. REINÍCIO AUTOMÁTICO (caso crash)
    Restart = "on-failure";
    RestartSec = "10s";
  };

  # --- CRIA OS DIRETÓRIOS QUE O COCKPIT PRECISA ---
  systemd.tmpfiles.rules = [
    "d /var/log/cockpit 0750 cockpit-ws cockpit-ws -"
    "d /var/lib/cockpit 0750 cockpit-ws cockpit-ws -"
    "d /var/cache/cockpit 0750 cockpit-ws cockpit-ws -"
  ];

}

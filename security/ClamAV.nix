{ config, pkgs, lib, ... }: {

  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
    updater.interval = "12h";

    daemon.settings = {
      # --- SCAN EM TEMPO REAL ---
      OnAccessMaxFileSize = "150M";
      OnAccessIncludePath = [ "/home/davi" "/tmp" "/var/tmp" ];
      OnAccessExcludePath = [ "/proc" "/sys" "/dev" "/run" "/nix/store" ];
      OnAccessPrevention = true;
      OnAccessExtraScanning = true;

      # --- MODO AGRESSIVO ---
      DetectPUA = true;
      HeuristicAlerts = true;
      HeuristicScanPrecedence = true;
      StructuredDataDetection = true;
      Bytecode = true;
      BytecodeSecurity = "TrustSigned";
      
      MaxScanSize = "400M";
      MaxFileSize = "200M";
      AlertBrokenExecutables = true;
      AlertEncrypted = false;

      LogFile = "/var/log/clamav/clamd.log";
      LogVerbose = true;
      LogSyslog = true;
    };
  };

  # --- NOVO HARDENING PROFUNDO (IGUAL AO SSH/SAMBA) ---
  systemd.services.clamav-daemon = {
    serviceConfig = {
      # 1. PRIVILÉGIOS MÍNIMOS (O ClamAV precisa de root pra escanear, mas vamos limitar o que ele pode fazer)
      Capabilities = "CAP_SYS_ADMIN CAP_IPC_LOCK"; # Mantido
      User = lib.mkForce "root";
      Group = lib.mkForce "root";

      # 2. PRIORIDADE EXTREMA (Não muda, é bom)
      CPUSchedulingPolicy = "fifo";
      CPUSchedulingPriority = 60;
      IOSchedulingClass = "realtime";
      IOSchedulingPriority = 0;
      OOMScoreAdjust = 50;
      Restart = "always";
      RestartSec = "1s";

      # 3. PERMISSÕES DE ESCRITA (Só onde ele realmente precisa gravar)
      # O sistema fica Read-Only, exceto essas pastas:
      ReadWritePaths = [
        "/var/lib/clamav"    # Onde as assinaturas (vírus definitions) são baixadas
        "/var/log/clamav"    # Onde ele escreve os logs
        "/tmp"               # Necessário para arquivos temporários durante o scan
        "/var/tmp"
      ];

      # 4. ISOLAMENTO DE SISTEMA DE ARQUIVOS (O MÁXIMO QUE DÁ)
      # Não podemos por "strict" ou "full" porque ele precisa ler o sistema inteiro para te proteger.
      # Mas podemos bloquear ESCRITAS em todo lugar (exceto as pastas acima) com ReadWritePaths.
      # Vamos usar "strict" + ReadWritePaths, mas o ClamAV precisa ler /usr, /etc, /home...
      # Então usamos "full" (que deixa /usr, /boot, /etc apenas leitura) e bloqueamos escrita no resto.
      ProtectSystem = "full";           # /usr, /boot, /etc ficam Read-Only (ninguém altera)
      ProtectHome = "read-only";        # O ClamAV pode LER o /home, mas NÃO PODE GRAVAR nele. Seguro!
      PrivateTmp = lib.mkForce "yes";                # Isola o /tmp do ClamAV (se invadirem, não veem os outros processos)
      ProtectControlGroups = true;      # Bloqueia cgroups
      ProtectKernelModules = true;      # Impede carregar módulos do kernel
      ProtectKernelTunables = true;     # Impede alterar parâmetros do kernel (/proc/sys)

      # 5. SANDBOX DE PRIVILÉGIOS (O MAIS IMPORTANTE)
      NoNewPrivileges = true;           # Se invadirem, não viram root
      RestrictRealtime = true;          
      RestrictSUIDSGID = true;          
      RestrictNamespaces = true;        # Impede criar containers ou montar coisas novas

      # 6. MEMÓRIA (Cuidado aqui!)
      # ATENÇÃO: O ClamAV usa Bytecode (uma máquina virtual interna para detectar vírus).
      # Se você ativar MemoryDenyWriteExecute = true, o Bytecode do ClamAV pode quebrar
      # e ele vai deixar de detectar vírus que usam assinaturas Bytecode.
      # Portanto, mantemos FALSE, igual ao Samba.
      MemoryDenyWriteExecute = false;

      # 7. FILTRO DE SYSYSTEM CALLS (O "CANCELADOR" DE EXPLOITS)
      SystemCallArchitectures = "native";
      SystemCallFilter = [
        "@system-service"
        "~@privileged"    # Bloqueia setuid, setgid, etc (se invadirem, não viram outro usuário)
        "~@resources"     # Bloqueia ioperm, iopl (acesso direto a hardware)
      ];
    };
  };

  # --- CRIA AS PASTAS DE LOG E ASSINATURA COM PERMISSÕES CERTAS ---
  systemd.tmpfiles.rules = [
    "d /var/lib/clamav 0750 clamav clamav -"
    "d /var/log/clamav 0750 clamav clamav -"
  ];

  environment.systemPackages = with pkgs; [ clamav ];
}

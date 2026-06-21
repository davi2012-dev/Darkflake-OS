{ config, pkgs, ... }: { 
  services.openssh = { 
    enable = true; 
    startWhenNeeded = true; 

    settings = { 
      AllowTcpForwarding = false; 
      X11Forwarding = false; 
      AllowAgentForwarding = false; 
      PermitTunnel = false; 

      PasswordAuthentication = false; 
      KbdInteractiveAuthentication = false; 
      PermitRootLogin = "no"; 

      ClientAliveInterval = 300; 
      ClientAliveCountMax = 2; 

      LoginGraceTime = 20; 
      MaxAuthTries = 3; 
      MaxSessions = 2; 
      MaxStartups = "10:30:60"; 

      LogLevel = "VERBOSE"; 

      # Algoritmos modernos 
      KexAlgorithms = [ 
        "mlkem768x25519-sha256" 
        "curve25519-sha256" 
      ]; 

      Ciphers = [ 
        "aes256-gcm@openssh.com" 
        "chacha20-poly1305@openssh.com" 
      ]; 

      Macs = [ 
        "hmac-sha2-512-etm@openssh.com" 
        "umac-128-etm@openssh.com" 
      ]; 

      # reduz fingerprinting 
      VersionAddendum = "none"; 

      # evita variáveis perigosas 
      PermitUserEnvironment = false; 

      # menos superfície 
      Compression = false; 

      # idle sessions 
      TCPKeepAlive = false; 

      # chave pública apenas 
      PubkeyAuthentication = true; 
    }; 
  }; 

  # --- ENDURECIMENTO PROFUNDO (CORRIGIDO) ---
  systemd.services."sshd@".serviceConfig = {
    # PERMITE ESCRITA NOS DIRETÓRIOS QUE O SSH PRECISA
    ReadWritePaths = [
      "/run/sshd"          # Socket de autenticação
      "/var/empty"         # Diretório chroot para privilege separation
      "/var/log"           # Para logs (se você ativar)
    ];

    # Restrições de sistema de arquivos
    ProtectSystem = "strict";          # Máxima proteção (read-only em todo o sistema)
    ProtectHome = "read-only";         # Permite ler ~/.ssh/authorized_keys
    PrivateTmp = "yes";                # Isola /tmp
    ProtectControlGroups = "yes";
    ProtectKernelModules = "yes";
    ProtectKernelTunables = "yes";

    # Sandbox de privilégios
    NoNewPrivileges = "yes";
    RestrictRealtime = "yes";
    RestrictSUIDSGID = "yes";
    RestrictNamespaces = "yes";

    # O SSH não usa JIT, então podemos ativar
    MemoryDenyWriteExecute = "yes";

    # Filtro de syscalls (seguro, sem bloquear setuid)
    SystemCallArchitectures = "native";
    SystemCallFilter = [
      "@system-service"
      "~@resources"        # Bloqueia ioperm, iopl, etc.
    ];
  };
}

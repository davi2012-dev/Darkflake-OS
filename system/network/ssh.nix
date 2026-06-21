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

      VersionAddendum = "none"; 
      PermitUserEnvironment = false; 
      Compression = false; 
      TCPKeepAlive = false; 
      PubkeyAuthentication = true; 
    }; 
  }; 

  # --- HARDENING QUE FUNCIONA (testado) ---
  systemd.services."sshd@".serviceConfig = {
    # DIRETÓRIOS QUE O SSH PRECISA LER/ESCREVER
    ReadWritePaths = [
      "/run/sshd"
      "/var/empty"
    ];

    # Proteções (sem exageros)
    ProtectSystem = "full";           # /usr, /boot, /etc read-only
    ProtectHome = "read-only";        # Leitura de ~/.ssh autorizada
    PrivateTmp = "yes";               # Isola /tmp
    ProtectControlGroups = "yes";
    ProtectKernelModules = "yes";
    ProtectKernelTunables = "yes";

    # Sem escalada de privilégios
    NoNewPrivileges = "yes";
    RestrictRealtime = "yes";
    RestrictSUIDSGID = "yes";
    RestrictNamespaces = "yes";

    # Proteção de memória (SSH não precisa de JIT)
    MemoryDenyWriteExecute = "yes";

    # Syscalls filtradas (sem bloquear setuid)
    SystemCallArchitectures = "native";
    SystemCallFilter = [
      "@system-service"
      "~@resources"
    ];

    # Evita problemas de limite de arquivos abertos
    LimitNOFILE = 4096;
  };
}

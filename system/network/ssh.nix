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

  # --- HARDENING MÍNIMO (APENAS O ESSENCIAL) ---
  systemd.services."sshd@".serviceConfig = {
    # Permissões de escrita
    ReadWritePaths = [
      "/run/sshd"
      "/var/empty"
    ];

    # Apenas algumas proteções básicas (nada que impeça o funcionamento)
    ProtectSystem = "full";          # Menos restritivo que "strict"
    ProtectHome = "read-only";
    PrivateTmp = "yes";
    NoNewPrivileges = "yes";
    SystemCallArchitectures = "native";
    SystemCallFilter = [
      "@system-service"
      "~@resources"
    ];
    # Remove tudo que possa quebrar:
    # - RestrictNamespaces, RestrictRealtime, RestrictSUIDSGID (deixamos desativados)
  };
}

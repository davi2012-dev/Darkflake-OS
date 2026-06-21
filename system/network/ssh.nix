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

  # --- Endurecimento profundo do SSHd via Systemd (Template p/ Socket Activation) ---
systemd.services."sshd@".serviceConfig = {
  ProtectSystem = "strict";
  ProtectHome = "read-only";           # Permite ler ~/.ssh/authorized_keys
  PrivateTmp = true;
  ProtectControlGroups = true;
  ProtectKernelModules = true;
  ProtectKernelTunables = true;
  NoNewPrivileges = true;              # Impede escalada APÓS o login (seguro)
  RestrictRealtime = true;
  RestrictSUIDSGID = true;
  RestrictNamespaces = true;
  MemoryDenyWriteExecute = false;      # Correto para o SSH (privilege separation)
  SystemCallArchitectures = "native";
  SystemCallFilter = [ "@system-service" "~@resources" ];
};
}

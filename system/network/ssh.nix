{ config, pkgs, ... }: {
  services.fail2ban = {
    enable = true;
    maxretry = 5;
    bantime = "1h";
    bantime-increment = {
      enable = true;
      multipliers = "1 2 4 8 16 32 64 128 256";
      maxtime = "168h";  # 1 semana
      overalljails = true;
    };
  };

  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    
    hostKeys = [
      { path = "/etc/ssh/ssh_host_ed25519_key"; type = "ed25519"; }
    ];
    
    settings = {
      # Usuários
      AllowUsers = [ "davi" ];
      
      # Autenticação
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitEmptyPasswords = false;
      PubkeyAuthentication = true;
      
      # Permissões
      PermitRootLogin = "no";
      X11Forwarding = config.services.xserver.enable;  
      AllowTcpForwarding = false;
      AllowAgentForwarding = false;
      PermitTunnel = false;
      PermitUserEnvironment = false;
      
      # Conexão
      ClientAliveInterval = 300;
      ClientAliveCountMax = 2;
      LoginGraceTime = 20;
      MaxAuthTries = 3;
      MaxSessions = 5;
      MaxStartups = "10:30:60";
      
      # Log
      LogLevel = "VERBOSE";
      UseDns = false;
      TCPKeepAlive = false;
      Compression = false;
      PerSourcePenalties = "crash:3600s authfail:3600s max:86400s";
      VersionAddendum = "none";
      KexAlgorithms = [
        "mlkem768x25519-sha256"      # Pós-quântico
        "curve25519-sha256"          # Moderno
      ];
      
      Ciphers = [
        "aes256-gcm@openssh.com"     # AES com GCM
        "chacha20-poly1305@openssh.com" # Stream cipher
      ];
      
      Macs = [
        "hmac-sha2-512-etm@openssh.com"
        "umac-128-etm@openssh.com"
      ];
      
      HostKeyAlgorithms = [ "ssh-ed25519" ];
    };
  };

  programs.mosh = {
    enable = true;
    openFirewall = true;
    withUtempter = true;
  };
}

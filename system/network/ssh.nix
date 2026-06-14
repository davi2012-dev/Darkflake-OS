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
 }

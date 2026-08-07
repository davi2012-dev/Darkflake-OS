{ config, pkgs, ... }:
{
  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    ports = [ 2222 ]; 
    openFirewall = true; 
    hostKeys = [
      { path = "/etc/ssh/ssh_host_ed25519_key"; type = "ed25519"; }
    ];
    settings = {
      AllowTcpForwarding = false;
      X11Forwarding = false;
      AllowAgentForwarding = false;
      PermitTunnel = false;
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      PermitEmptyPasswords = false;
      ClientAliveInterval = 300;
      ClientAliveCountMax = 2;
      LoginGraceTime = 20;
      MaxAuthTries = 3;
      MaxSessions = 5;
      MaxStartups = "10:30:60";
      LogLevel = "VERBOSE";
      UseDns = false;
      AllowUsers = [ "davi" ];
      PerSourcePenalties = "crash:3600s authfail:3600s max:86400s";
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
      HostKeyAlgorithms = [ "ssh-ed25519" ];
      VersionAddendum = "none";
      PermitUserEnvironment = false;
      Compression = false;
      TCPKeepAlive = false;
      PubkeyAuthentication = true;
    };
  };
}

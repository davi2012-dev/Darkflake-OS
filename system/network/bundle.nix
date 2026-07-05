{ config, pkgs, ... }: { 

   imports = [ 
     ./ssh.nix 
     ./dns.nix 
     ./samba.nix 
     ./cockpit.nix 
     ./firewall.nix 
     ./analysis.nix  
     ./Adguard.nix 
     ./searxng.nix   
     ./caddy.nix
   ]; 

   # --- IDENTIFICAÇÃO DO SISTEMA ---
   networking.hostName = "Darkflake"; 

   # --- BLOQUEIO NATIVO DE MALWARE/ADS (Steven Black) ---
   networking.stevenblack.enable = false;

   # --- PRIVACIDADE E ROTEAMENTO ---
   networking.tempAddresses = "default"; # Ativa IPs temporários/aleatórios no IPv6

   # --- CONFIGURAÇÃO DE DNS ESTRITA ---
   networking.nameservers = [ 
     "127.0.0.1" 
     "::1" 
   ]; 
   networking.networkmanager.dns = "none"; 
   networking.resolvconf.enable = false; 
   services.resolved.enable = false; 

   # --- GERENCIAMENTO DE REDE (NetworkManager + IWD) ---
   networking.networkmanager = { 
     enable = true; 
     wifi.backend = "iwd"; 
     wifi.macAddress = "random";     # MAC Aleatório no Wi-Fi
     ethernet.macAddress = "random"; # MAC Aleatório no Cabo
   }; 

   # --- CONFIGURAÇÃO ULTRA-SEGURA DE HORA (NTS) ---
   
   # 1. Desativar o cliente de hora padrão do systemd
   services.timesyncd.enable = false; 

   # 2. Chrony com NTS (Puxa a hora da internet com criptografia)
   services.chrony = {
     enable = true;
     servers = [ 
       "time.cloudflare.com iburst nts"
       "nts.ekspresso.se iburst nts"
       "a.st1.ntp.br iburst nts"
       "b.st1.ntp.br iburst nts"
       "nts.netnod.se iburst nts"
       "ptbtime1.ptb.de iburst nts"
     ];
     extraConfig = ''
       # Corrige a hora bruscamente se o erro for maior que 1s nos 3 primeiros boots
       makestep 1.0 3
     '';
   };
}

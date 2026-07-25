{ config, pkgs, ... }: 

{ 
   services.samba = { 
     enable = true; 
     openFirewall = false; 

     settings = { 
       global = { 
         workgroup = "WORKGROUP"; 

         "server min protocol" = "SMB3_11"; 
         "disable netbios" = "yes"; 
         "smb ports" = "445"; 
         interfaces = "127.0.0.1 tailscale0"; 
         "bind interfaces only" = "yes"; 
         "map to guest" = "never"; 
         "restrict anonymous" = "2"; 
         "server signing" = "mandatory"; 
         "server smb encrypt" = "mandatory";
         "server string" = ""; 
         "load printers" = "no"; 
         printing = "bsd"; 
         "printcap name" = "/dev/null"; 
         "disable spoolss" = "yes"; 
         "log level" = "1"; 
         "use sendfile" = "yes"; 
         "aio read size" = "1"; 
         "aio write size" = "1"; 
       }; 

       Public = { 
         path = "/srv/samba/public"; 

         browseable = "no"; 
         "read only" = "yes"; 
         "guest ok" = "no"; 
       }; 
     }; 
   }; 

   # DESLIGA O NMBD 
   systemd.services.samba-nmbd.enable = false; 

   # --- Endurecimento profundo do processo smbd via Systemd ---
   systemd.services.samba-smbd.serviceConfig = {
     # Restrições de Sistema de Arquivos
     ReadWritePaths = [ "/var/log/samba" "/var/lib/samba"  "/srv/samba/public" ];
     ProtectSystem = "full";          
     ProtectHome = "read-only";        
     PrivateTmp = true;                
     ProtectControlGroups = true;       
     ProtectKernelModules = true;      
     ProtectKernelTunables = true;     
     NoNewPrivileges = true;       
     RestrictRealtime = true;            
     RestrictSUIDSGID = true;            
     MemoryDenyWriteExecute = false;
     SystemCallArchitectures = "native";
     SystemCallFilter = [ "@system-service" "~@resources" ];
   };
}

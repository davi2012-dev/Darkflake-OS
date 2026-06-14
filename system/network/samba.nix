{ config, pkgs, ... }: 

 { 
   services.samba = { 
     enable = true; 
     openFirewall = false; 

     settings = { 
       global = { 
         workgroup = "WORKGROUP"; 

         # SMB moderno apenas 
         "server min protocol" = "SMB3_11"; 

         # mata NetBIOS legado 
         "disable netbios" = "yes"; 
         "smb ports" = "445"; 

         # interfaces 
         interfaces = "127.0.0.1 tailscale0"; 
         "bind interfaces only" = "yes"; 

         # segurança 
         "map to guest" = "never"; 
         "restrict anonymous" = "2"; 
         "server signing" = "mandatory"; 

         # menos fingerprinting 
         "server string" = ""; 

         # sem impressoras 
         "load printers" = "no"; 
         printing = "bsd"; 
         "printcap name" = "/dev/null"; 
         "disable spoolss" = "yes"; 

         # logs mínimos 
         "log level" = "1"; 

         # performance extrema para arquitetura EPYC 
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
 }

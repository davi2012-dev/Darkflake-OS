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

   # --- Endurecimento profundo do processo smbd via Systemd ---
   systemd.services.samba-smbd.serviceConfig = {
     # Restrições de Sistema de Arquivos
     ProtectSystem = "full";             # Transforma /usr, /boot, /etc em Read-Only (Não usamos 'strict' para ele poder mapear /srv)
     ProtectHome = "read-only";          # Permite ler se houver compartilhamento no /home, mas não gravar
     PrivateTmp = true;                  # Cria um /tmp exclusivo e isolado para o Samba
     ProtectControlGroups = true;        # Bloqueia modificações nos cgroups do Kernel
     ProtectKernelModules = true;        # Impede o processo de carregar módulos do Kernel
     ProtectKernelTunables = true;       # Bloqueia alterações em caminhos como /proc/sys

     # Isolamento de Privilégios e Segurança de Execução
     NoNewPrivileges = true;             # Impede escalada de privilégios

     # Restrições de Sandbox de Segurança
     RestrictRealtime = true;            
     RestrictSUIDSGID = true;            
     
     # ATENÇÃO: O Samba usa alocação dinâmica e otimizações de memória para I/O e aio_read.
     # Manter MemoryDenyWriteExecute como false evita travar conexões simultâneas pesadas.
     MemoryDenyWriteExecute = false;

     # Filtro de Chamadas do Sistema (Syscalls autorizadas adaptadas para o Samba)
     SystemCallArchitectures = "native";
     SystemCallFilter = [ "@system-service" "~@privileged" "~@resources" ];
   };
}

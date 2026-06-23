{ config, pkgs, ... }:

{
  services.caddy = {
    enable = true;
    email = "DaviMigue@proton.me";

    virtualHosts = {
      "nextcloud.Darkflake.local" = {
        extraConfig = ''
          tls internal
          reverse_proxy localhost:8085
        '';
      };
      "jellyfin.Darkflake.local" = {
        extraConfig = ''
          tls internal
          reverse_proxy localhost:8096
        '';
      };
      "librechat.Darkflake.local" = {
        extraConfig = ''
          tls internal
          reverse_proxy localhost:3080
        '';
      };
      "homarr.Darkflake.local" = {
        extraConfig = ''
          tls internal
          reverse_proxy localhost:8083
        '';
      };
      "stirling.Darkflake.local" = {
        extraConfig = ''
          tls internal
          reverse_proxy localhost:8089
        '';
      };
      "chat.Darkflake.local" = {
        extraConfig = ''
         tls internal
         reverse_proxy localhost:7000
       '';
      };
      "metube.Darkflake.local" = {
        extraConfig = ''
          tls internal
          reverse_proxy localhost:8081
        '';
      };
      "netdata.Darkflake.local" = {
        extraConfig = ''
          tls internal
          reverse_proxy localhost:19999
        '';
      };
      "ha.Darkflake.local" = {
        extraConfig = ''
          tls internal
          reverse_proxy localhost:8123
        '';
      };
      "portainer.Darkflake.local" = {
        extraConfig = ''
          tls internal
          reverse_proxy localhost:9443 {
            transport http {
              tls_insecure_skip_verify
            }
          }
        '';
       };
    };
  };

  # --- Endurecimento profundo do processo via Systemd (O que limpa a nota do Lynis) ---
  systemd.services.caddy.serviceConfig = {
    # Restrições de Sistema de Arquivos (Isolamento total)
    ProtectSystem = "strict";            # Transforma o sistema em Read-Only para o Caddy
    ProtectHome = true;                 # Impede leitura da pasta /home
    PrivateTmp = true;                  # Cria um /tmp exclusivo e limpo
    ProtectControlGroups = true;        # Bloqueia modificações nos cgroups do Kernel
    ProtectKernelModules = true;        # Impede o processo de carregar módulos do Kernel
    ProtectKernelTunables = true;       # Bloqueia alterações em caminhos como /proc/sys

    # Isolamento de Privilégios e Usuário
    NoNewPrivileges = true;             # Impede escalada de privilégios
    CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ]; # Libera unicamente o bind de portas baixas (80/443)
    AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];

    # Restrições de Sandbox de Segurança
    RestrictNamespaces = true;          
    RestrictRealtime = true;            
    RestrictSUIDSGID = true;            
    MemoryDenyWriteExecute = true;      # Mitiga ataques de estouro de buffer (Buffer Overflow)

    # Filtro de Chamadas do Sistema (Syscalls autorizadas)
    SystemCallArchitectures = "native";
    SystemCallFilter = [ "@system-service" "~@privileged" "~@resources" ];
  };
}

{ config, pkgs, ... }:

{
  # Serviço Caddy
  services.caddy = {
    enable = true;
    email = "DaviMigue@proton.me";  # Obrigatório para Let's Encrypt

    # Defina os virtual hosts para cada serviço
    virtualHosts = {
      # Exemplo: nextcloud.seudominio.local
      "nextcloud.seudominio.local" = {
        extraConfig = ''
          reverse_proxy localhost:8085
        '';
      };

      "jellyfin.seudominio.local" = {
        extraConfig = ''
          reverse_proxy localhost:8096
        '';
      };

      "librechat.seudominio.local" = {
        extraConfig = ''
          reverse_proxy localhost:3080
        '';
      };

      "homarr.seudominio.local" = {
        extraConfig = ''
          reverse_proxy localhost:8083
        '';
      };

      "stirling.seudominio.local" = {
        extraConfig = ''
          reverse_proxy localhost:8089
        '';
      };

      "metube.seudominio.local" = {
        extraConfig = ''
          reverse_proxy localhost:8081
        '';
      };

      "netdata.seudominio.local" = {
        extraConfig = ''
          reverse_proxy localhost:19999
        '';
      };

      "ha.seudominio.local" = {
        extraConfig = ''
          reverse_proxy localhost:8123
        '';
      };

      # Portainer já tem HTTPS nativo (9443), mas você pode querer proxyar também
      "portainer.seudominio.local" = {
        extraConfig = ''
          reverse_proxy localhost:9443 {
            transport http {
              tls_insecure_skip_verify
            }
          }
        '';
      };
    };
  };

  # Certifique-se de que as portas 80 e 443 estão liberadas (já estão nas suas regras)
  # networking.firewall.allowedTCPPorts já inclui 80 e 443, então está ok.
}

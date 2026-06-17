{ config, pkgs, ... }:

{
  # Serviço Caddy
  services.caddy = {
    enable = true;
    email = "DaviMigue@proton.me";  # Obrigatório para Let's Encrypt

    # Defina os virtual hosts para cada serviço
    virtualHosts = {
      # Exemplo: nextcloud.seudominio.local
      "nextcloud.Darkflake.local" = {
        extraConfig = ''
          reverse_proxy localhost:8085
        '';
      };

      "jellyfin.Darkflake.local" = {
        extraConfig = ''
          reverse_proxy localhost:8096
        '';
      };

      "librechat.Darkflake.local" = {
        extraConfig = ''
          reverse_proxy localhost:3080
        '';
      };

      "homarr.Darkflake.local" = {
        extraConfig = ''
          reverse_proxy localhost:8083
        '';
      };

      "stirling.Darkflake.local" = {
        extraConfig = ''
          reverse_proxy localhost:8089
        '';
      };

      "metube.Darkflake.local" = {
        extraConfig = ''
          reverse_proxy localhost:8081
        '';
      };

      "netdata.Darkflake.local" = {
        extraConfig = ''
          reverse_proxy localhost:19999
        '';
      };

      "ha.Darkflake.local" = {
        extraConfig = ''
          reverse_proxy localhost:8123
        '';
      };

      # Portainer já tem HTTPS nativo (9443), mas você pode querer proxyar também
      "portainer.Darkflake.local" = {
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

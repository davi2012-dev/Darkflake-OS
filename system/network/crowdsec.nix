{ config, pkgs, ... }: {
  services.crowdsec = {
    enable = true;
    # Se quiser participar da rede colaborativa:
    # enrollKeyFile = "/path/to/key";
    settings = {
      # Configuração da API local
      lapi = {
        listen_uri = "127.0.0.1:8080";
      };
      # Opcional: central API (capi)
      # capi = {
      #   enabled = true;
      # };
    };
    # Para o CrowdSec funcionar, você precisa definir fontes de log (acquisitions)
    # Exemplo simples para SSH:
    acquisitions = {
      "sshd" = {
        filenames = [ "/var/log/auth.log" ];
        labels = {
          type = "syslog";
        };
      };
    };
  };

  # Bouncer para nftables (bloqueia IPs)
  services.crowdsec-firewall-bouncer = {
    enable = true;
    # Configuração se necessário
    # settings = {
    #   api_url = "http://127.0.0.1:8080";
    # };
  };
}

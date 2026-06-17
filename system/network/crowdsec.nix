{ config, pkgs, ... }: {
  services.crowdsec = {
    enable = true;
    # Opcional: inscrever na rede colaborativa
    # enrollKeyFile = "/path/to/enroll-key";
    settings = {
      api.server = {
        listen_uri = "127.0.0.1:8080";
      };
    };
  };

  # Bouncer para nftables (bloqueia os IPs)
  services.crowdsec-firewall-bouncer = {
    enable = true;
    # Configuração para nftables (já que você usa networking.nftables.enable = true)
    # Veja a documentação oficial para detalhes[reference:10]
  };
}

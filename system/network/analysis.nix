{ config, pkgs, ... }: {

  # Instala o EtherApe e outras ferramentas de análise de rede
  environment.systemPackages = with pkgs; [
    etherape    # Monitoramento gráfico de tráfego
    nmap        # Scanner de rede
    lynis
    wireshark
    bind.dnsutils
    vulnix  
];
  
  
  security.wrappers.etherape = {
  source = "${pkgs.etherape}/bin/etherape";
  capabilities = "cap_net_raw,cap_net_admin+eip";
  owner = "root";
  group = "wireshark"; 
  permissions = "u+rx,g+rx,o+r";
}; 

  programs.bandwhich.enable = true;
  programs.wireshark.enable = true;
}

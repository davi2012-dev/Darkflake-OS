{ config, pkgs, ... }: {

  # Ativa o Open vSwitch no sistema
  virtualisation.vswitch = {
    enable = true;
    
    # Reseta o banco de dados de rede a cada boot para garantir consistência declarativa
    resetOnStart = true; 
  };

  # Instala ferramentas extras utilitárias para gerenciar o Switch Virtual no terminal
  environment.systemPackages = with pkgs; [
    openvswitch
  ];
}

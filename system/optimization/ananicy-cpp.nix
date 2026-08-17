{ config, pkgs, ... }:

{
  # 1. Habilita o daemon Ananicy-CPP
  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-rules-cachyos;
  };

  # 3. Garante que o pacote esteja disponível no sistema para monitoramento
  environment.systemPackages = [ 
    pkgs.ananicy-cpp 
  ];
}

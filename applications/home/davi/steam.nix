{ config, pkgs, ... }:

{
  # 1. Habilita o Steam e Ferramentas de Compatibilidade
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; 
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    extest.enable = true;
    protontricks.enable = true;
    gamescopeSession = {
      enable = true;
    };
  };

  # Controlador de comandos universal para a Steam
  programs.streamcontroller.enable = true;

  # Pacotes complementares essenciais para a Steam e Overlays
  environment.systemPackages = with pkgs; [
    steam-rom-manager  # Para injetar emuladores na biblioteca da Steam
    sgdboop            # Para aplicar capas nos jogos direto do SteamGridDB
    steamtinkerlaunch  # Ferramenta avançada de tweaks para o Proton
    mangohud           # Para monitorizar FPS, uso do AMD EPYC e da GPU no ecrã
  ];
}

{ config, pkgs, ... }: {
  # 1. Habilita o Steam 
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
  programs.streamcontroller.enable = true;
  # 2. Pacotes de Diversão e Lazer
  environment.systemPackages = with pkgs; [
    # Jogos e Emuladores
    azahar
    hydralauncher
    ppsspp
    dolphin-emu
    pcsx2            
    heroic            
    prismlauncher    
    ryubing
    supertuxkart
    supertux
    dosbox
    rpcs3
    extremetuxracer
    tuxpaint
    steam-rom-manager
    sgdboop
    steamtinkerlaunch
    mangohud
    er-patcher
    xbill
    # Visual e Personalização
    cmatrix
    gpufetch
    speechd
    espeak-ng         
    pipes            
    hollywood
    asciiquarium         
    sl
    cowsay
    oneko
    figlet
    espeak
    cava
    xeyes
    gnugo
    nyancat
    links2
    peaclock
    openrgb-with-all-plugins
    bibata-cursors
    papirus-icon-theme
  ];

  # 3. Gamemode (Melhora a performance do i5 nos jogos)
  programs.gamemode.enable = true;
}

{ config, pkgs, ... }:

{
  # 1. Pacotes de Diversão e Lazer
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
    er-patcher
    xbill
    wineWow64Packages.unstableFull
    wine-discord-ipc-bridge
    dxvk
    vkd3d-proton

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

  programs.gamemode.enable = true;
}

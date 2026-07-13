{ config, pkgs, ... }: {

  # 1. Habilita o Steam e Ferramentas de Compatibilidade no Sistema
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

  # 2. Pacotes de Diversão, Lazer e Utilitários Steam
  environment.systemPackages = with pkgs; [
    # Suporte e Extras da Steam
    steam-rom-manager
    sgdboop
    steamtinkerlaunch
    mangohud

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

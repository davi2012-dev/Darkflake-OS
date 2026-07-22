{ config, pkgs, ... }: {

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

  environment.systemPackages = with pkgs; [
    sgdboop
    steamtinkerlaunch
    mangohud
    hydralauncher
    heroic
    prismlauncher
    supertuxkart
    supertux
    extremetuxracer
    tuxpaint
    er-patcher
    xbill
    wineWow64Packages.unstableFull
    dxvk
    vkd3d-proton

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

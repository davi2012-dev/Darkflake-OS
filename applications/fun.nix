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
    dxvk
    vkd3d-proton

    cmatrix
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
    bibata-cursors
    papirus-icon-theme
  ];

  programs.gamemode.enable = true;
}

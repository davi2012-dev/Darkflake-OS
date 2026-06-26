{ pkgs, lib, config, ... }:

{
  # 1. Suporte a XDG
  xdg.enable = true; 

  # 2. Variáveis de Sessão
  home.sessionVariables = {
    XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Pictures";
    XDG_PICTURES_DIR = "${config.home.homeDirectory}/Pictures";
    THEOSHELL_TRASH_DIR = "${config.xdg.dataHome}/theoshell/trash";
    EDITOR = "code";
  };

  # 3. Imports
  imports = [
    ./eza.nix
    ./fd.nix
    ./fzf.nix
    ./git.nix
    ./zoxide.nix
    ./fish.nix
    ./starship.nix
    ./fastfetch.nix
    ./spotify.nix
    ./mpv.nix
    ./cava.nix
  ];

  # 4 X11
  xsession.preferStatusNotifierItems = true;
  xsession.numlock.enable = true;

  # deamon 
  services.activitywatch = {
  enable = true;
  package = pkgs.aw-server-rust;
  };
  services.blanket.enable = true;
  services.amberol.enable = true;
  services.podman.autoUpdate.enable = true;
  services.podman.enableTypeCheck = true;
  services.amberol.enableRecoloring = true;
  services.amberol.replaygain = "album";
  services.xsettingsd.enable = true;
  services.plan9port.plumber.enable = true;
  services.plan9port.fontsrv.enable = true;
  services.plan9port.package = pkgs.plan9port-wayland;
  # 5. Pacotes
  home.packages = with pkgs; [
    tree
    wget
    hugo
    openconnect
    qemu
    exiftool
    ffmpeg
    figlet
    imagemagick
    nodejs_24
    python3
    cargo
    rustc
    sqlite

    (if stdenv.isLinux then platformio else platformio-core)
  ];

  # 6 . Compatibilidade
  programs.man.generateCaches =
    lib.mkIf pkgs.stdenv.isDarwin false;

  programs.home-manager.enable = true;

  home.stateVersion = "25.11";
}

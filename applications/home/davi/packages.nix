{ pkgs, lib, ... }:

{
  # Pacotes do usuário
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

  # Compatibilidade: caches de man só no Linux
  programs.man.generateCaches = lib.mkIf pkgs.stdenv.isDarwin false;

  programs.home-manager.enable = true;
}

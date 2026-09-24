{ pkgs, ... }:

{
  # Serviços em background
  services.activitywatch = {
    enable = true;
    package = pkgs.aw-server-rust;
  };

  services.amberol = {
    enable = true;
    enableRecoloring = true;
    replaygain = "album";
  };

  services.podman.autoUpdate.enable = true;
  services.xsettingsd.enable = true;

  services.plan9port = {
    plumber.enable = true;
    fontsrv.enable = true;
    package = pkgs.plan9port-wayland;
  };
}

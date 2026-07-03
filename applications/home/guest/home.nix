{ pkgs, config, ... }:

{
  xdg.enable = true;

  home.username = "guest";
  home.homeDirectory = "/home/guest";

  home.sessionVariables = {
    XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Pictures";
    XDG_PICTURES_DIR = "${config.home.homeDirectory}/Pictures";
  };

  xsession.preferStatusNotifierItems = true;
  xsession.numlock.enable = true;

  services.blanket.enable = true;
  services.amberol.enable = true;

  home.packages = with pkgs; [
    firefox
    vlc
    libreoffice
    ark
    gwenview
    wget
    tree
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "25.11";
}

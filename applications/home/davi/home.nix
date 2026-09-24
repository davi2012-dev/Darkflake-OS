{ pkgs, lib, config, inputs, ... }:

{
  # 1. Suporte a XDG
  xdg.enable = true;

  # 2. Variáveis de Sessão
  home.sessionVariables = {
    XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Pictures";
    XDG_PICTURES_DIR = "${config.home.homeDirectory}/Pictures";
    THEOSHELL_TRASH_DIR = "${config.xdg.dataHome}/theoshell/trash";
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # 3. Imports (organizados por categoria)
  imports = [
    ./cli
    ./shell
    ./desktop
    ./dev
    ./services.nix
    ./programs.nix
    ./packages.nix
  ];

  # 4. X11
  xsession.preferStatusNotifierItems = true;
  xsession.numlock.enable = true;

  # 5. Estado
  home.stateVersion = "25.11";
}

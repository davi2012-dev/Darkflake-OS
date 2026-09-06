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
    ./cava.nix
    ./librewolf.nix
    ./lazyvim.nix
    ./opencode.nix
  ];

  # 4 X11
  xsession.preferStatusNotifierItems = true;
  xsession.numlock.enable = true;

  # services 
  services.activitywatch = {
  enable = true;
  package = pkgs.aw-server-rust;
  };
  services.amberol.enable = true;
  services.podman.autoUpdate.enable = true;
  services.amberol.enableRecoloring = true;
  services.amberol.replaygain = "album";
  services.xsettingsd.enable = true;
  services.plan9port.plumber.enable = true;
  services.plan9port.fontsrv.enable = true;
  services.plan9port.package = pkgs.plan9port-wayland;
  programs.nix-search-tv.enable = true; 
  programs.nix-search-tv.enableTelevisionIntegration = true;
  programs.television.enable = true;
  programs.television.enableFishIntegration = true;
  programs.nix-your-shell.enable = true;
  programs.nix-your-shell.enableFishIntegration = true;
  programs.nix-your-shell.nix-output-monitor.enable = true;
  programs.nix-init.enable = true;
  programs.nix-index.enable = true; 
  programs.nix-index.enableFishIntegration = true;
  programs.topgrade.enable = true;
  programs.mangohud.enable = true;
  programs.lazysql.enable = true;

  # === Rust/C Modern CLI (home-manager programs) ===
  programs.bat = {
    enable = true;
    config = {
      theme = "Catppuccin Mocha";
      style = "numbers,changes,header,grid";
    };
  };

  programs.bottom = {
    enable = true;
    settings = {
      colors = {
        high_battery_color = "red";
        mid_battery_color = "yellow";
        low_battery_color = "green";
      };
    };
  };

  programs.delta = {
    enable = true;
    options = {
      navigate = true;
      line-numbers = true;
      side-by-side = true;
      syntax-theme = "Catppuccin Mocha";
    };
  };

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

    # === Rust/C Modern CLI ===
    dust              # du visual bonito
    procs             # ps moderno com ports/docker/memoria
    sd                # sed simplificado
    hexyl             # hex viewer colorido
    tokei             # conta linhas de codigo
    hyperfine         # benchmarking rigoroso
    bandwhich         # traffic por processo
    gitui             # git TUI rapido
    tealdeer          # tldr rapido
    broot             # tree interativo com navigacao
    ouch              # compressao multi-formato
    xh                # curl moderno e bonito
    dogdns            # dig moderno
    watchexec         # executa comando ao alterar ficheiros
    grex              # gera regex de exemplos
    navi              # cheatsheet interativo
    erdtree           # tree com tamanho
  ];

  # 6 . Compatibilidade
  programs.man.generateCaches =
    lib.mkIf pkgs.stdenv.isDarwin false;

  programs.home-manager.enable = true;

  home.stateVersion = "25.11";
}

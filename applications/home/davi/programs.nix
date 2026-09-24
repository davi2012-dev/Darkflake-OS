{
  # Programas habilitados fora das categorias (cli/shell/desktop/dev)
  programs.nix-search-tv = {
    enable = true;
    enableTelevisionIntegration = true;
  };

  programs.nix-your-shell = {
    enable = true;
    enableFishIntegration = true;
    nix-output-monitor.enable = true;
  };

  programs.television = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.nix-init.enable = true;
  programs.topgrade.enable = true;
  programs.mangohud.enable = true;
  programs.lazysql.enable = true;
}

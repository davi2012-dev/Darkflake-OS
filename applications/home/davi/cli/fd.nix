{ ... }:
{
  programs.fd = {
    enable = true;
    hidden = true;
    ignores = [
      ".git/"
      ".gitignore"
      "node_modules/"
      "__pycache__/"
      ".venv/"
      "venv/"
      "target/"
      "dist/"
      "build/"
      ".vscode/"
      ".idea/"
      ".DS_Store"
      "*.swp"
      "*.swo"
    ];
  };

  
  home.shellAliases = {
    # --- Busca rápida ---
    fd = "fd --hidden";           # busca com hidden files por padrão
    fda = "fd -a";                # todas as files (sem ignore .gitignore)
    fdt = "fd --type";            # buscar por tipo
    fdf = "fd --type f";          # apenas files
    fdd = "fd --type d";          # apenas dirs
    fdl = "fd --type l";          # apenas symlinks
    
    # --- Extensions ---
    fdrs = "fd --extension rs";   # arquivos .rs
    fdpy = "fd --extension py";   # arquivos .py
    fdjs = "fd --extension js";   # arquivos .js
    fdts = "fd --extension ts";   # arquivos .ts
    fdnix = "fd --extension nix"; # arquivos .nix
    
    # --- Case sensitivity ---
    fdi = "fd --case-sensitive";  # case-sensitive search
    
    # --- Execution ---
    fdx = "fd --exec";            # executar comando em cada resultado
    
    # --- Úteis ---
    fdg = "fd -t f --exec grep -l"; # buscar conteúdo em arquivos
  };
}

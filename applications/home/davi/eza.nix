{ ... }:
{
  programs.eza = {
    enable = true;
    enableZshIntegration = false;
    enableFishIntegration = false;

    colors = "auto";
    icons = "auto";
  };

  # ✅ Aliases minimalistas para eza
  home.shellAliases = {
    # --- Básicos (substituem ls) ---
    l = "eza -l";                          # list format
    la = "eza -la";                        # com hidden files
    ll = "eza -lh";                        # com tamanho legível
    lla = "eza -lah";                      # tudo
    
    # --- Árvore ---
    lt = "eza -T";                         # tree simples
    ltl = "eza -Tl";                       # tree com detalhes
    
    # --- Sorting ---
    lsz = "eza -lh --sort=size";           # por tamanho
    lsm = "eza -lh --sort=modified";       # por modificação
    lsn = "eza -lh --sort=name";           # por nome
    
    # --- Git aware ---
    lg = "eza -l --git";                   # mostra status git
    lga = "eza -la --git";                 # com hidden + git
    
    # --- Colorido e rápido ---
    ls = "eza";                            # padrão
    lx = "eza -lbhH --git";                # muito detalhado
    
    # --- One per line (útil em scripts) ---
    l1 = "eza -1";
  };
}

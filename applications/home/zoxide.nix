{ ... }:
{
  programs.zoxide = {
    enable = true;

    enableZshIntegration = true;
    enableFishIntegration = true;

    options = [ "--cmd cd" ];  
  };

  # ✅ Aliases minimalistas para zoxide
  home.shellAliases = {
    # --- Navigation ---
    z = "cd";                  
    zi = "zoxide query -i";     # interactive mode
    
    # --- Frecency (Most used dirs) ---
    zl = "zoxide query -l";     # list all frecent dirs
    zr = "zoxide remove -i";    # remove frecent dir (interactive)
    
    # --- Cleanup ---
    zc = "zoxide remove -i";    # alias para remover
  };
}

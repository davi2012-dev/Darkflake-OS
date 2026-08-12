{ ... }:

{
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    options = [ "--cmd cd" ];
  };

  programs.fish.functions.zi = {
    description = "cd interativo via zoxide (fzf)";
    body = ''
      set -l dir (zoxide query -i -- $argv)
      and cd "$dir"
    '';
  };

  home.shellAliases = {
    z = "cd";       
    zl = "zoxide query -l"; 
    zr = "zoxide remove -i"; 
  };
}

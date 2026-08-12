{ ... }:
{
  programs.zoxide = {
    enable = true;


    enableFishIntegration = true;

    options = [ "--cmd cd" ];  
  };

  home.shellAliases = {
    z = "cd";                  
    zi = "zoxide query -i";    
    zl = "zoxide query -l";   
    zr = "zoxide remove -i";   
  };
}

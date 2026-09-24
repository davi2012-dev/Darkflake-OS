{ ... }:

{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      add_newline = true;
      follow_symlinks = true;
      format = "$directory$git_branch$git_status$python$nix_shell$nodejs$character";
      palette = "catppuccin_mocha";
      palettes.catppuccin_mocha = {
        rosewater = "#f5e0dc";
        flamingo = "#f2cdcd";
        pink = "#f5c2e7";
        mauve = "#cba6f7";
        red = "#f38ba8";
        maroon = "#eba0ac";
        peach = "#fab387";
        yellow = "#f9e2af";
        green = "#a6e3a1";
        teal = "#94e2d5";
        sky = "#89dceb";
        sapphire = "#74c7ec";
        blue = "#89b4fa";
        lavender = "#b4befe";
        text = "#cdd6f4";
        subtext1 = "#bac2de";
        subtext0 = "#a6adc8";
        overlay2 = "#9399b2";
        overlay1 = "#7f849c";
        overlay0 = "#6c7086";
        surface2 = "#585b70";
        surface1 = "#45475a";
        surface0 = "#313244";
        base = "#1e1e2e";
        mantle = "#181825";
        crust = "#11111b";
      };
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
        vimcmd_symbol = "[❮](bold teal)";
        vimcmd_replace_symbol = "[❮](bold mauve)";
        vimcmd_replace_one_symbol = "[❮](bold mauve)";
        vimcmd_visual_symbol = "[❮](bold yellow)";
      };
      directory = {
        format = "[◖](fg:blue)[ $path ](bg:blue fg:crust)[◗](fg:blue) ";
        truncation_length = 3;
        truncation_symbol = "…/";
      };
      git_branch = {
        format = "[◖](fg:mauve)[ $symbol$branch ](bg:mauve fg:crust)[◗](fg:mauve) ";
        symbol = " ";
      };
      git_status = {
        format = "[◖](fg:peach)[ $all_status$ahead_behind ](bg:peach fg:crust)[◗](fg:peach) ";
      };
      python = {
        format = "[◖](fg:yellow)[ $symbol$version ](bg:yellow fg:crust)[◗](fg:yellow) ";
        symbol = " ";
      };
      nix_shell = {
        format = "[◖](fg:sapphire)[ $symbol$state ](bg:sapphire fg:crust)[◗](fg:sapphire) ";
        symbol = " ";
      };
      nodejs = {
        format = "[◖](fg:green)[ $symbol$version ](bg:green fg:crust)[◗](fg:green) ";
        symbol = " ";
      };
    };
  };
}

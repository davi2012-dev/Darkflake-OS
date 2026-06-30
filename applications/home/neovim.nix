{ config, pkgs, lib, unstable, ... }:

{
  programs.neovim = {
    enable = true;
    plugins = with unstable.vimPlugins; [
      neorg              # do unstable
      nvim-nio
      nui-nvim
      plenary-nvim
      neorg-telescope
      nvim-cmp
      nvim-treesitter.withAllGrammars
    ];
    extraLuaPackages = luaPkgs: with luaPkgs; [
      pathlib-nvim
      lua-utils-nvim
    ];
  };
}

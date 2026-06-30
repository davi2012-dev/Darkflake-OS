{ config, pkgs, lib, unstable, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = false;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    withPython3 = true;

    plugins = with unstable.vimPlugins; [
      neorg
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

    extraLuaConfig = ''
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.g.mapleader = " "

      require('neorg').setup {
        load = {
          ["core.defaults"] = {},
          ["core.norg.concealer"] = {},
          -- ["core.norg.completion"] removido
          ["core.norg.qol.toc"] = {},
          ["core.norg.journal"] = {
            config = { workspace = "journal" },
          },
        },
      }
    '';
  };
}

{ config, pkgs, lib, unstable, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    withPython3 = true;

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

    extraLuaConfig = ''
      -- Configuração básica
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.g.mapleader = " "

      -- Configuração do Neorg (ativa o plugin!)
      require('neorg').setup {
        load = {
          ["core.defaults"] = {},
          ["core.norg.concealer"] = {},
          ["core.norg.completion"] = {
            config = { engine = "nvim-cmp" },
          },
          ["core.norg.qol.toc"] = {},
          ["core.norg.journal"] = {
            config = { workspace = "journal" },
          },
        },
      }
    '';
  };
}

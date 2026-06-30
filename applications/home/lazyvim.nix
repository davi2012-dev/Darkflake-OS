{ config, pkgs, lib, lazyvim, ... }:

{
  imports = [
    lazyvim.homeManagerModules.default
  ];

  programs.lazyvim = {
    enable = true;

    installCoreDependencies = true;

    extras = {
      lang.nix.enable = true;
      lang.python = {
        enable = true;
        installDependencies = true;
        installRuntimeDependencies = true;
      };
      lang.go = {
        enable = true;
        installDependencies = true;
        installRuntimeDependencies = true;
      };
    };

    extraPackages = with pkgs; [
      nixd
      alejandra
    ];

    plugins = {
      neorg = lazyvim.lib.lazyConfig {
        plugin = "nvim-neorg/neorg";
        opts = {
          load = {
            "core.defaults" = {};         
            "core.norg.concealer" = {};
            "core.norg.qol.toc" = {};
            "core.norg.journal" = {
              config = { workspace = "journal"; };
            };
          };
        };
      };
    };

    config = {
      options = ''
        vim.opt.relativenumber = true
        vim.opt.number = true
      '';
      keymaps = ''
        vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
      '';
    };
  };
}

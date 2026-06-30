{ config, pkgs, lib, inputs, ... }:

{
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
      
      ui.mini-animate.enable = true;
      editor.dial.enable = true;
      coding.mini-surround.enable = true;
    };

    extraPackages = with pkgs; [
      nixd
      alejandra
      # Removido: nerdfonts.override ...
    ];

    plugins = {
      catppuccin = inputs.lazyvim.lib.lazyConfig {
        plugin = "catppuccin/nvim";
        opts = {
          flavour = "mocha";
          transparent_background = false;
          term_colors = true;
        };
      };

      colorscheme = inputs.lazyvim.lib.lazyConfig {
        plugin = "LazyVim/LazyVim";
        opts = { colorscheme = "catppuccin"; };
      };

      harpoon = inputs.lazyvim.lib.lazyConfig {
        plugin = "ThePrimeagen/harpoon";
        opts = { };
      };

      undotree = inputs.lazyvim.lib.lazyConfig {
        plugin = "mbbill/undotree";
        opts = { };
      };

      todo-comments = inputs.lazyvim.lib.lazyConfig {
        plugin = "folke/todo-comments.nvim";
        opts = { };
      };
    };

    config = {
      options = ''
        vim.opt.relativenumber = true
        vim.opt.number = true
        vim.opt.cursorline = true
        vim.opt.scrolloff = 8
        vim.opt.sidescrolloff = 8
      '';
      keymaps = ''
        vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
        vim.keymap.set("n", "<leader>q", "<cmd>bd<cr>", { desc = "Close Buffer" })
        vim.keymap.set("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
        vim.keymap.set("n", "<S-Tab>", "<cmd>bprev<cr>", { desc = "Prev Buffer" })
      '';
    };
  };
}

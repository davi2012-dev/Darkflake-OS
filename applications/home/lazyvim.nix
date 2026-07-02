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
      editor.aerial.enable = true;
    };

    extraPackages = with pkgs; [
      nixd
      alejandra
      lazygit
      fd
      ripgrep
      tree-sitter
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
      
      toggleterm = inputs.lazyvim.lib.lazyConfig {
        plugin = "akinsho/toggleterm.nvim";
        config = ''function()
          require("toggleterm").setup({
            open_mapping = [[<c-\>]],
            direction = "float",
          })
        end'';
      };

      codecompanion = inputs.lazyvim.lib.lazyConfig {
        plugin = "olimorris/codecompanion.nvim";
        config = ''function()
          require("codecompanion").setup({
            strategies = {
              chat = { adapter = "ollama" },
              inline = { adapter = "ollama" },
            },
            adapters = {
              ollama = function()
                return require("codecompanion.adapters").extend("ollama", {
                  schema = {
                    model = { default = "qwen2.5-coder:1.5b" },
                  },
                })
              end,
            },
          })
        end'';
      };
    };

    config = {
      options = ''
        vim.opt.relativenumber = true
        vim.opt.number = true
        vim.opt.cursorline = true
        vim.opt.scrolloff = 8
        vim.opt.sidescrolloff = 8
        vim.opt.termguicolors = true
        vim.opt.undofile = true
        vim.opt.swapfile = false
        vim.opt.lang = "pt_BR"
        vim.opt.spell = true
        vim.opt.spelllang = { "pt_br", "en" }
      '';
      
      keymaps = ''
        vim.g.mapleader = " "
        
        vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
        vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Find in Files" })
        vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
        
        vim.keymap.set("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
        vim.keymap.set("n", "<S-Tab>", "<cmd>bprev<cr>", { desc = "Prev Buffer" })
        vim.keymap.set("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Close Buffer" })
        
        vim.keymap.set({"n", "i", "v"}, "<C-s>", "<Esc><cmd>w<cr>", { desc = "Save" })
        vim.keymap.set({"n", "i", "v"}, "<C-x>", "<Esc><cmd>q<cr>", { desc = "Quit" })
        
        vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<cr>", { desc = "Terminal" })
        
        vim.keymap.set({"n", "v"}, "<leader>ia", "<cmd>CodeCompanionActions<cr>", { desc = "IA Actions" })
        vim.keymap.set({"n", "v"}, "<leader>ic", "<cmd>CodeCompanionChat<cr>", { desc = "IA Chat" })
        
        vim.keymap.set("n", "<leader>cs", "<cmd>AerialToggle<cr>", { desc = "Symbols" })
        
        vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Window Left" })
        vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Window Down" })
        vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Window Up" })
        vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Window Right" })
      '';
    };
  };
}

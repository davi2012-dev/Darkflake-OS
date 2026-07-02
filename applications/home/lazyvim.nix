{ config, pkgs, lib, inputs, ... }:

{
  programs.lazyvim = {
    enable = true;
    installCoreDependencies = true;

    extras = {
      # Linguagens
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
      
      # Interface
      ui.mini-animate.enable = true;
      editor.dial.enable = true;
      coding.mini-surround.enable = true;
      editor.aerial.enable = true;
      
      ai.copilot.enable = true;
      coding.yanky.enable = true;
      editor.inc-rename.enable = true;
      test.core.enable = true;
      util.dot.enable = true;
      util.mini-hipatterns.enable = true;
    };

    extraPackages = with pkgs; [
      nixd
      alejandra
      lazygit
      fd
      ripgrep
      tree-sitter
      # Dependências para copilot
      nodejs
      # Para test.core
      gnumake
      # Para util.dot
      nil
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

      # Configuração específica para copilot
      copilot = inputs.lazyvim.lib.lazyConfig {
        plugin = "github/copilot.vim";
        config = ''function()
          vim.g.copilot_no_tab_map = true
          vim.g.copilot_assume_mapped = true
        end'';
      };

      # Configuração para neotest
      neotest = inputs.lazyvim.lib.lazyConfig {
        plugin = "nvim-neotest/neotest";
        config = ''function()
          require("neotest").setup({
            adapters = {
              require("neotest-python")({
                dap = { justMyCode = false }
              }),
              require("neotest-go")({
                args = { "-count=1", "-timeout=60s" }
              })
            }
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
        
        -- Configurações para copilot
        vim.g.copilot_enabled = true
      '';
      
      keymaps = ''
        vim.g.mapleader = " "
        
        -- Telescope
        vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
        vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Find in Files" })
        vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
        vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help" })
        
        -- Buffers
        vim.keymap.set("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
        vim.keymap.set("n", "<S-Tab>", "<cmd>bprev<cr>", { desc = "Prev Buffer" })
        vim.keymap.set("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Close Buffer" })
        
        -- Save/Quit
        vim.keymap.set({"n", "i", "v"}, "<C-s>", "<Esc><cmd>w<cr>", { desc = "Save" })
        vim.keymap.set({"n", "i", "v"}, "<C-x>", "<Esc><cmd>q<cr>", { desc = "Quit" })
        
        -- Terminal
        vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<cr>", { desc = "Terminal" })
        
        -- IA
        vim.keymap.set({"n", "v"}, "<leader>ia", "<cmd>CodeCompanionActions<cr>", { desc = "IA Actions" })
        vim.keymap.set({"n", "v"}, "<leader>ic", "<cmd>CodeCompanionChat<cr>", { desc = "IA Chat" })
        
        -- Symbols
        vim.keymap.set("n", "<leader>cs", "<cmd>AerialToggle<cr>", { desc = "Symbols" })
        
        -- Windows
        vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Window Left" })
        vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Window Down" })
        vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Window Up" })
        vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Window Right" })
        
        -- Copilot
        vim.keymap.set("i", "<C-l>", "copilot#Accept()", { expr = true, desc = "Copilot Accept" })
        vim.keymap.set("i", "<C-;>", "copilot#Next()", { expr = true, desc = "Copilot Next" })
        
        -- Yanky (melhor yank/paste)
        vim.keymap.set("n", "p", "<Plug>(YankyPutAfter)", { desc = "Yanky Put After" })
        vim.keymap.set("n", "P", "<Plug>(YankyPutBefore)", { desc = "Yanky Put Before" })
        
        -- Inc-Rename
        vim.keymap.set("n", "<leader>rn", "<cmd>IncRename<cr>", { desc = "Incremental Rename" })
        
        -- Neotest
        vim.keymap.set("n", "<leader>tr", "<cmd>Neotest run<cr>", { desc = "Test Run" })
        vim.keymap.set("n", "<leader>tf", "<cmd>Neotest run file<cr>", { desc = "Test File" })
        vim.keymap.set("n", "<leader>ts", "<cmd>Neotest summary<cr>", { desc = "Test Summary" })
        
        -- Dotfiles (util.dot)
        vim.keymap.set("n", "<leader>ed", "<cmd>e ~/.config/nvim/<cr>", { desc = "Edit Dotfiles" })
        
        -- Mini Hipatterns (destaca cores)
        vim.keymap.set("n", "<leader>hc", "<cmd>TSHighlightCaptures<cr>", { desc = "Highlight Colors" })
      '';
    };
  };
}

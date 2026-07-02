{ config, pkgs, lib, inputs, ... }:

{
  programs.lazyvim = {
    enable = true;
    installCoreDependencies = true;

    extras = {
      # Linguagens Inteligentes (LSP)
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
            
      # Interface e utilitários
      ui.mini-animate.enable = true;
      editor.dial.enable = true;
      coding.mini-surround.enable = true;
      
      # ================= NAVEGADOR DE SÍMBOLOS =================
      editor.aerial.enable = true;
    };

    extraPackages = with pkgs; [
      nixd
      alejandra
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
      
      yanky = inputs.lazyvim.lib.lazyConfig {
        plugin = "gbprod/yanky.nvim";
        opts = { };
      };

      inc-rename = inputs.lazyvim.lib.lazyConfig {
        plugin = "smjonas/inc-rename.nvim";
        opts = { };
      };

      mini-hipatterns = inputs.lazyvim.lib.lazyConfig {
        plugin = "nvim-mini/mini.hipatterns";   
        opts = { };
      };

      harpoon = inputs.lazyvim.lib.lazyConfig {
        plugin = "ThePrimeagen/harpoon";
        opts = { };
      };

      undotree = inputs.lazyvim.lib.lazyConfig {
        plugin = "mbbill/undotree";
        config = ''function()
          require("undotree").setup()
        end'';
      };

      todo-comments = inputs.lazyvim.lib.lazyConfig {
        plugin = "folke/todo-comments.nvim";
        opts = { };
      };

      octo = inputs.lazyvim.lib.lazyConfig {
        plugin = "pwntester/octo.nvim";
        opts = { };
      };

      # ================= EMACS GAMES REPOSITORY =================
      # Injetando o ikouchiha47/games.nvim diretamente no Nix
      games-nvim = inputs.lazyvim.lib.lazyConfig {
        plugin = "ikouchiha47/games.nvim";
        config = ''function()
          -- Carrega o repositório de jogos estilo emacs/terminal
          -- Comandos disponíveis: :Hangman, :MineSweeper, :Pacman
        end'';
      };

      # ================= TERMINAL FLUTUANTE =================
      toggleterm = inputs.lazyvim.lib.lazyConfig {
        plugin = "akinsho/toggleterm.nvim";
        config = ''function()
          require("toggleterm").setup({
            open_mapping = [[<c-\>]],
            direction = "float",
            }}
          })
        end'';
      };

      # ================= IA LOCAL (OLLAMA) =================
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

        -- ========== PORTUGUÊS (PT-BR) ==========
        vim.opt.lang = "pt_BR"
        vim.opt.langmenu = "pt_BR"
        vim.opt.spell = true
        vim.opt.spelllang = { "pt_br", "en" }
      '';
      
      keymaps = ''
        -- ========== ATALHOS EMACS / DOOM EMACS EM FUSION ==========
        -- Mapeamentos clássicos do gerenciador do Doom Emacs
        vim.keymap.set("n", "<leader>.", "<cmd>Telescope find_files<cr>", { desc = "Emacs: Find File" })
        vim.keymap.set("n", "<leader>,", "<cmd>Telescope buffers<cr>", { desc = "Emacs: Switch Buffer" })
        vim.keymap.set("n", "<leader>bb", "<cmd>Telescope buffers<cr>", { desc = "Emacs: List Buffers" })
        
        -- ========== ARCADE / EMACS GAMES SHORTCUTS ==========
        -- Atalhos Rápidos para abrir os games injetados do ikouchiha47
        vim.keymap.set("n", "<leader>g pac", "<cmd>Pacman<cr>", { desc = "Arcade: Play Pacman" })
        vim.keymap.set("n", "<leader>g mnv", "<cmd>MineSweeper<cr>", { desc = "Arcade: Play MineSweeper" })
        vim.keymap.set("n", "<leader>g jof", "<cmd>Hangman<cr>", { desc = "Arcade: Play Jogo da Forca" })

        -- ========== ATALHOS ESTILO NANO / GLOBAL ==========
        vim.keymap.set({'n', 'i', 'v'}, '<C-s>', '<Esc><cmd>w<cr>', { desc = "Save File" })
        vim.keymap.set({'n', 'i', 'v'}, '<C-x>', '<Esc><cmd>q<cr>', { desc = "Exit" })

        -- Buffer navegação
        vim.keymap.set("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
        vim.keymap.set("n", "<S-Tab>", "<cmd>bprev<cr>", { desc = "Prev Buffer" })
        vim.keymap.set("n", "<leader>q", "<cmd>bd<cr>", { desc = "Close Buffer" })

        -- ========== AJUDA DO TELESCOPE ==========
        vim.keymap.set("n", "<leader>hh", "<cmd>Telescope help_tags<cr>", { desc = "Help (Telescope)" })

        -- ========== ATALHOS DA IA LOCAL ==========
        vim.keymap.set({"n", "v"}, "<leader>ia", "<cmd>CodeCompanionActions<cr>", { desc = "IA: Actions" })
        vim.keymap.set({"n", "v"}, "<leader>ic", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "IA: Toggle Chat" })

        -- ========== ATALHOS DO AERIAL =================
        vim.keymap.set("n", "<leader>cs", "<cmd>AerialToggle<cr>", { desc = "Aerial: Code Symbols" })

        -- ========== PODMAN HOME LAB ==========
        vim.keymap.set("n", "<leader>pc", ":lua require('toggleterm').exec('podman ps -a')<CR>", { silent = true, desc = "Podman: List containers" })
      '';
    };
  };
}

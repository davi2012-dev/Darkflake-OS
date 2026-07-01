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
      
      # IA Integrada para dar pitacos e autocompletar ideias no projeto
      coding.copilot.enable = true; 
      
      # Interface e utilitários
      ui.mini-animate.enable = true;
      editor.dial.enable = true;
      coding.mini-surround.enable = true;
      util.toggleterm.enable = true; # OBRIGATÓRIO para fazer o atalho do Podman funcionar!
    };

    extraPackages = with pkgs; [
      nixd
      alejandra
      copilot-node-agent # Agente necessário para a IA funcionar em segundo plano
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

      # Scaneia seus arquivos atrás de TODO:, FIXME:, IDEIA:
      todo-comments = inputs.lazyvim.lib.lazyConfig {
        plugin = "folke/todo-comments.nvim";
        opts = { };
      };

      octo = inputs.lazyvim.lib.lazyConfig {
        plugin = "pwntester/octo.nvim";
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

        -- ========== PORTUGUÊS (PT-BR) ==========
        vim.opt.lang = "pt_BR"
        vim.opt.langmenu = "pt_BR"
        vim.opt.spell = true
        vim.opt.spelllang = { "pt_br", "en" }
      '';
      
      keymaps = ''
        -- ========== ATALHOS ESTILO NANO ==========
        -- Salvar com Ctrl + S em qualquer modo (Normal, Inserção, Visual)
        vim.keymap.set({'n', 'i', 'v'}, '<C-s>', '<Esc><cmd>w<cr>', { desc = "Save File (Nano Style)" })
        -- Sair com Ctrl + X
        vim.keymap.set({'n', 'i', 'v'}, '<C-x>', '<Esc><cmd>q<cr>', { desc = "Exit (Nano Style)" })

        -- Buffer navegação
        vim.keymap.set("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
        vim.keymap.set("n", "<S-Tab>", "<cmd>bprev<cr>", { desc = "Prev Buffer" })
        vim.keymap.set("n", "<leader>q", "<cmd>bd<cr>", { desc = "Close Buffer" })

        -- ========== AJUDA DO TELESCOPE ==========
        vim.keymap.set("n", "<leader>hh", "<cmd>Telescope help_tags<cr>", { desc = "Help (Telescope)" })

        -- ========== PODMAN HOME LAB ==========
        vim.keymap.set("n", "<leader>pc", function()
          local term = require("toggleterm.terminal").Terminal:new({
            cmd = "podman ps -a",
            direction = "float",
            hidden = true,
          })
          term:toggle()
        end, { desc = "Podman: List containers" })
      '';
    };
  };
}

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
      # (opcional) Para o dicionário pt_BR, você pode instalar o aspell com o dicionário
      # aspellDicts.pt_BR
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

  # A configuração do tema deve ser assim
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

  # Correção: o plugin foi renomeado
  mini-hipatterns = inputs.lazyvim.lib.lazyConfig {
    plugin = "nvim-mini/mini.hipatterns";   
    opts = { };
  };

  harpoon = inputs.lazyvim.lib.lazyConfig {
    plugin = "ThePrimeagen/harpoon";
    opts = { };
  };

  # Correção: undotree pode ser removido ou configurado corretamente
  # Opção 1: Remover (se não for essencial)
  # undotree = inputs.lazyvim.lib.lazyConfig {
  #   plugin = "mbbill/undotree";
  #   opts = { };
  # };

  # Opção 2: Manter, mas com a configuração adequada (se você realmente usa)
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

  # GitHub
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
        -- Ativa correção ortográfica com dicionário português e inglês
        vim.opt.lang = "pt_BR"
        vim.opt.langmenu = "pt_BR"
        vim.opt.spell = true
        vim.opt.spelllang = { "pt_br", "en" }
        -- O arquivo de dicionário será criado em ~/.config/nvim/spell/pt_BR.utf-8.add
        -- Para gerá-lo, execute dentro do Neovim: :mkspell! ~/.config/nvim/spell/pt_BR.utf-8.add
      '';
      
      keymaps = ''
        -- Atalhos existentes
        vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
        vim.keymap.set("n", "<leader>q", "<cmd>bd<cr>", { desc = "Close Buffer" })
        vim.keymap.set("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
        vim.keymap.set("n", "<S-Tab>", "<cmd>bprev<cr>", { desc = "Prev Buffer" })

        -- ========== AJUDA ==========
        -- Abre a documentação do Neovim via Telescope
        vim.keymap.set("n", "<leader>hh", "<cmd>Telescope help_tags<cr>", { desc = "Help (Telescope)" })

        -- ========== PODMAN ==========
        -- Abre um terminal flutuante com o comando `podman ps -a`
        vim.keymap.set("n", "<leader>pc", function()
          local term = require("toggleterm.terminal").Terminal:new({
            cmd = "podman ps -a",
            direction = "float",
            hidden = true,
          })
          term:toggle()
        end, { desc = "Podman: List containers" })

        -- Você pode criar outros atalhos para outros comandos do Podman:
        -- vim.keymap.set("n", "<leader>pl", function()
        --   local term = require("toggleterm.terminal").Terminal:new({
        --     cmd = "podman logs -f",
        --     direction = "float",
        --     hidden = true,
        --   })
        --   term:toggle()
        -- end, { desc = "Podman: Follow logs" })
      '';
    };
  };
}

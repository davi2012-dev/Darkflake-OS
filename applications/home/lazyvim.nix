{ config, pkgs, lib, inputs, ... }:

{
  programs.lazyvim = {
    enable = true;

    installCoreDependencies = true;

    # Extras do LazyVim (linguagens e ferramentas)
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
      
      # Extras visuais e de produtividade (opcionais, mas recomendados)
      ui.mini-animate.enable = true;      # Animações suaves
      editor.dial.enable = true;          # Incrementar/decrementar números
      coding.mini-surround.enable = true; # Manipular delimiters com facilidade
    };

    # Pacotes adicionais do sistema
    extraPackages = with pkgs; [
      nixd          # LSP para Nix
      alejandra     # Formatador Nix
      # Fontes e ícones (opcional, mas recomendo)
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];

    # Plugins extras para turbinar sua experiência
    plugins = {
      # 1. TEMA: Catppuccin (o mais bonito e suave)
      catppuccin = inputs.lazyvim.lib.lazyConfig {
        plugin = "catppuccin/nvim";
        opts = {
          flavour = "mocha";      # "latte", "frappe", "macchiato", "mocha"
          transparent_background = false;
          term_colors = true;
        };
      };

      # 2. Diz ao LazyVim para usar o Catppuccin como tema padrão
      colorscheme = inputs.lazyvim.lib.lazyConfig {
        plugin = "LazyVim/LazyVim";
        opts = { colorscheme = "catppuccin"; };
      };

      # 3. Harpoon: Gerencie arquivos rapidamente (criado pelo ThePrimeagen)
      harpoon = inputs.lazyvim.lib.lazyConfig {
        plugin = "ThePrimeagen/harpoon";
        opts = { };
      };

      # 4. Undotree: Visualize o histórico de alterações
      undotree = inputs.lazyvim.lib.lazyConfig {
        plugin = "mbbill/undotree";
        opts = { };
      };

      # 5. Todo-comments: Destaque e liste comentários TODO, FIXME, etc.
      todo-comments = inputs.lazyvim.lib.lazyConfig {
        plugin = "folke/todo-comments.nvim";
        opts = { };
      };
      
      # 6. (Opcional) Telescope extra: Busca mais avançada (já vem no LazyVim, mas adiciono como exemplo)
      # telescope-fzf-native = inputs.lazyvim.lib.lazyConfig {
      #   plugin = "nvim-telescope/telescope-fzf-native.nvim";
      #   opts = { };
      # };
    };

    # Configurações personalizadas
    config = {
      options = ''
        vim.opt.relativenumber = true
        vim.opt.number = true
        vim.opt.cursorline = true      # destaca a linha atual
        vim.opt.scrolloff = 8          # mantém 8 linhas de margem ao rolar
        vim.opt.sidescrolloff = 8
      '';
      keymaps = ''
        -- Salvar com <leader>w
        vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
        
        -- Fechar buffer sem fechar o Neovim
        vim.keymap.set("n", "<leader>q", "<cmd>bd<cr>", { desc = "Close Buffer" })
        
        -- Navegação entre buffers com Tab (como em editores modernos)
        vim.keymap.set("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
        vim.keymap.set("n", "<S-Tab>", "<cmd>bprev<cr>", { desc = "Prev Buffer" })
      '';
    };
  };
}

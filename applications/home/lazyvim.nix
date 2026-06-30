{ config, pkgs, lib, lazyvim, ... }:

{
  imports = [
    lazyvim.homeManagerModules.default
  ];

  programs.lazyvim = {
    enable = true;

    # Instala dependências básicas (git, ripgrep, fd, etc.)
    installCoreDependencies = true;

    # Extras (habilite os que você usa)
    extras = {
      # Línguas
      lang.nix.enable = true;
      lang.python = {
        enable = true;
        installDependencies = true;        # ruff, etc.
        installRuntimeDependencies = true; # python3
      };
      lang.go = {
        enable = true;
        installDependencies = true;
        installRuntimeDependencies = true;
      };
      # lang.typescript.enable = true; # se precisar
    };

    # Pacotes adicionais (opcional)
    extraPackages = with pkgs; [
      nixd        # LSP para Nix
      alejandra   # Formatador Nix
      # outros que você queira
    ];

    # Plugins extras (ex: Neorg)
    plugins = {
      # Exemplo: adicionar Neorg como plugin
      neorg = lazyvim.lib.lazyConfig {
        plugin = "nvim-neorg/neorg";
        # Configuração opcional (pode ser Lua inline ou arquivo)
        opts = {
          load = {
            ["core.defaults"] = {};
            ["core.norg.concealer"] = {};
            ["core.norg.qol.toc"] = {};
            ["core.norg.journal"] = {
              config = { workspace = "journal"; };
            };
          };
        };
      };
    };

    # Configurações personalizadas (opcional)
    config = {
      options = ''
        vim.opt.relativenumber = true
        vim.opt.number = true
      '';
      keymaps = ''
        vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
      '';
    };

    # Se tiver uma pasta com arquivos .lua de configuração, use:
    # configFiles = ./my-lazyvim-config;
  };
}

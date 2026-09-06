{ pkgs, ... }:

{
  # ========== OPENCODE - Agente de Código com IA ==========
  programs.opencode = {
    enable = true;

    # 1. Pacotes extras disponíveis no PATH do opencode
    # (usado para skills/plugins que o opencode instala via uv)
    extraPackages = with pkgs; [
      uv
    ];

    # 2. Configuração principal (opencode.json)
    settings = {
      # Update declarativo via nix (nada de autoupdate solto)
      autoupdate = false;
    };

    # 3. Configuração do TUI (tui.json)
    tui = {
      theme = "darkflake-catppuccin-mocha";
    };

    # 4. Tema custom: Catppuccin Mocha (igual ao resto do sistema)
    themes = {
      "darkflake-catppuccin-mocha" = {
        theme = {
          # Cores base
          primary = "#b4befe";
          secondary = "#89b4fa";
          accent = "#cba6f7";
          error = "#f38ba8";
          warning = "#fab387";
          success = "#a6e3a1";
          info = "#89dceb";

          # Texto
          text = "#cdd6f4";
          textMuted = "#a6adc8";

          # Fundo
          background = "#1e1e2e";
          backgroundPanel = "#181825";
          backgroundElement = "#313244";
          border = "#45475a";
          borderActive = "#585b70";
          borderSubtle = "#313244";

          # Diff
          diffAdded = "#a6e3a1";
          diffRemoved = "#f38ba8";
          diffContext = "#bac2de";
          diffHunkHeader = "#89b4fa";
          diffHighlightAdded = "#a6e3a1";
          diffHighlightRemoved = "#f38ba8";
          diffAddedBg = "#313244";
          diffRemovedBg = "#313244";
          diffContextBg = "#181825";
          diffLineNumber = "#6c7086";
          diffAddedLineNumberBg = "#313244";
          diffRemovedLineNumberBg = "#313244";

          # Markdown
          markdownText = "#cdd6f4";
          markdownHeading = "#cba6f7";
          markdownLink = "#89b4fa";
          markdownLinkText = "#89b4fa";
          markdownCode = "#f5c2e7";
          markdownBlockQuote = "#a6adc8";
          markdownEmph = "#f2cdcd";
          markdownStrong = "#f9e2af";
          markdownHorizontalRule = "#45475a";
          markdownListItem = "#89b4fa";
          markdownListEnumeration = "#f9e2af";
          markdownImage = "#74c7ec";
          markdownImageText = "#74c7ec";
          markdownCodeBlock = "#bac2de";

          # Syntax
          syntaxComment = "#6c7086";
          syntaxKeyword = "#cba6f7";
          syntaxFunction = "#89b4fa";
          syntaxVariable = "#94e2d5";
          syntaxString = "#a6e3a1";
          syntaxNumber = "#fab387";
          syntaxType = "#f9e2af";
          syntaxOperator = "#89dceb";
          syntaxPunctuation = "#9399b2";
        };
      };
    };
  };
}

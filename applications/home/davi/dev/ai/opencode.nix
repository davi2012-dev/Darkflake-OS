{ config, pkgs, ... }:

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

      # 2.1 MCP servers (iguais aos do opencode do CachyOS)
      mcp = {
        playwright = {
          type = "local";
          command = [
            "npx"
            "-y"
            "@playwright/mcp@latest"
            "--browser"
            "chromium"
          ];
          enabled = true;
        };
        memory = {
          type = "local";
          command = [
            "npx"
            "-y"
            "@modelcontextprotocol/server-memory"
          ];
          enabled = true;
        };
        fetch = {
          type = "local";
          command = [
            "npx"
            "-y"
            "mcp-server-fetch"
          ];
          enabled = true;
        };
        wikipedia = {
          type = "local";
          command = [
            "npx"
            "-y"
            "wikipedia-mcp"
          ];
          enabled = true;
        };
        weather = {
          type = "local";
          command = [
            "npx"
            "-y"
            "@atorresg/weather-mcp"
          ];
          enabled = true;
        };
        chart = {
          type = "local";
          command = [
            "npx"
            "-y"
            "@antv/mcp-server-chart"
          ];
          enabled = true;
        };
        "sequential-thinking" = {
          type = "local";
          command = [
            "npx"
            "-y"
            "@modelcontextprotocol/server-sequential-thinking"
          ];
          enabled = true;
        };
        terminal = {
          type = "local";
          command = [
            "npx"
            "-y"
            "@wonderwhy-er/desktop-commander@latest"
          ];
          enabled = true;
        };
        context7 = {
          type = "local";
          command = [
            "npx"
            "-y"
            "@upstash/context7-mcp"
          ];
          enabled = true;
        };

        # github (desativado até criar o segredo no sops):
        #   1) sops secrets.yaml -> adicionar: github-token: <TOKEN>
        #   2) security/sops.nix -> adicionar sops.secrets."github-token"
        #   3) descomentar o bloco abaixo
        # github = {
        #   type = "local";
        #   command = [
        #     "npx"
        #     "-y"
        #     "@github/mcp-server"
        #     "stdio"
        #     "--toolsets"
        #     "git,issues,pull_requests,repos,users"
        #   ];
        #   environment = {
        #     GITHUB_PERSONAL_ACCESS_TOKEN = "${config.sops.secrets.github-token.path}";
        #   };
        #   enabled = true;
        # };
      };
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
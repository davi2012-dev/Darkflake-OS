{ config, pkgs, lib, ... }: {

  # --- Seu Buscador Próprio Sem Rastreio e Sem Cookies ---
  services.searx = {
    enable = true;
    # Usa o pacote moderno do SearXNG
    package = pkgs.searxng; 
    
    # Cria um banco de dados temporário na RAM para buscas instantâneas
    redisCreateLocally = true;

    settings = {
      server = {
        port = 8080;
        bind_address = "127.0.0.1";
        # Chave interna padrão para rodar o motor em memória
        secret_key = "UmaSenhaSuperSecretaAquiParaOsCookies"; 
      };

      # --- Configurações de UI: Bloqueio Total de Cookies ---
      ui = {
        default_theme = "simple";
        theme_args.simple_style = "auto"; # Segue o tema escuro do seu KDE Plasma
        
        # O PULO DO GATO: Proíbe o salvamento de cookies no navegador
        no_cookies = true; 
        hotkeys = "default";
      };

      search = {
        autocomplete = "duckduckgo"; # Sugestões de busca limpas
        safe_search = 0; # Filtro desativado (coloque 1 ou 2 se quiser ativar)
      };

      # Motores de busca ativos (Google, DuckDuckGo e Wikipédia)
      engines = [
        { name = "google"; engine = "google"; shortcut = "g"; }
        { name = "duckduckgo"; engine = "duckduckgo"; shortcut = "d"; }
        { name = "wikipedia"; engine = "wikipedia"; shortcut = "w"; }
      ];
    };
  };
}

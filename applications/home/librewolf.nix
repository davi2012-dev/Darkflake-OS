{ config, pkgs, ... }:

{
  programs.librewolf = {
    # 1. Ativa o programa globalmente
    enable = true;

    # 2. Define o pacote padrão do nixpkgs
    package = pkgs.librewolf;

    # 3. Força o pacote de idioma em Português do Brasil
    languagePacks = [ "pt-BR" ];

    # 4. Políticas Globais (Afetam todo o sistema e garantem privacidade)
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      
      # Garante que o navegador confie nos certificados locais (ex: Caddy para o .local)
      Certificates = {
        ImportEnterpriseRoots = true;
      };
    };

    # 5. Configuração do teu Perfil Declarativo
    profiles.darkflake = {
      id = 0;
      isDefault = true;
      name = "Darkflake";

      settings = {
        "webgl.disabled" = false; # Mantém o WebGL ativo para poderes jogar no navegador
        "privacy.resistFingerprinting" = true;
        "privacy.trackingprotection.enabled" = true;
        "intl.accept_languages" = "pt-br,pt"; # Informa os sites para abrirem em português
      };
    };
  };
}

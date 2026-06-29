{ config, pkgs, ... }:

{
  programs.librewolf = {
    # 1. Ativa o programa globalmente
    enable = true;

    # 2. Define o pacote (padrão estável do nixpkgs)
    package = pkgs.librewolf;

    # 3. Políticas Globais (Afetam todos os perfis do sistema)
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      
      # Aquela flag que conversamos para aceitar os certificados locais do Caddy
      Certificates = {
        ImportEnterpriseRoots = true;
      };
    };

    # 4. Configurações de Perfis (Onde entra a lista anterior)
    profiles.darkflake = {
      id = 0;
      isDefault = true;
      name = "Darkflake";

      settings = {
        "webgl.disabled" = false; # Mantém WebGL ativo para jogos de navegador
        "privacy.resistFingerprinting" = true;
        "privacy.trackingprotection.enabled" = true;
      };
    };
  };
}

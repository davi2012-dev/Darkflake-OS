{ config, pkgs, ... }:

{
  programs.librewolf = {
    enable = true;
    
    # Configurações de preferências do usuário
    settings = {
      "webgl.disabled" = true;
      "privacy.resistFingerprinting" = true;
      "privacy.trackingprotection.enabled" = true;
      "identity.fxaccounts.enabled" = true;
    };

    # Ativa as políticas corporativas (Enterprise Policies) para injetar a flag de certificados
    policies = {
      Certificates = {
        ImportEnterpriseRoots = true; # No Firefox/LibreWolf a flag de política chama-se assim
      };
    };
  };
}

{ config, pkgs, lib, ... }:

{
  # 1. Configuração do LibreWolf dentro do Host (Gera o perfil e idioma)
  programs.librewolf = {
    enable = true;
    languagePacks = [ "pt-BR" ];
    
    policies = {
      DisableTelemetry = true;
      Certificates.ImportEnterpriseRoots = true;
    };

    profiles.darkflake = {
      id = 0;
      isDefault = true;
      name = "Darkflake";
      settings = {
        "webgl.disabled" = false;
        "privacy.resistFingerprinting" = true;
        "privacy.trackingprotection.enabled" = true;
        # GARANTE O SUPORTE À CONTA SYNC:
        "identity.fxaccounts.enabled" = true; 
      };
    };
  };

  # 2. Declaração da MicroVM Isolada (Estilo Qubes OS)
  # Nota: Requer o input 'microvm' no seu flake.nix
  microvm.vms.librewolf-vm = {
    autostart = false; # Você inicia ela quando quiser navegar
    config = { ... }: {
      networking.hostName = "librewolf-appvm";
      
      # Compartilha a interface gráfica (Wayland/X11) do seu KDE com a VM
      virtualisation.microvm = {
        volumes = [ {
          # Monta uma pasta persistente para salvar os dados da sua Conta/Sync
          image = "/var/lib/microvms/librewolf-profile.img";
          mountPoint = "/home/user/.mozilla";
          size = 10240; # 10GB de espaço isolado para o perfil
        } ];
        
        # Compartilha os sockets de vídeo e áudio para o navegador abrir na sua tela
        shareDisplay = true; 
      };

      environment.systemPackages = [ pkgs.librewolf ];
    };
  };
}

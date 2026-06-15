{ config, pkgs, lib, ... }: {
  # Desabilita completamente o Lanzaboote
  boot.lanzaboote.enable = lib.mkForce false;

  # Habilita o systemd-boot simples
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # (Opcional) Se quiser manter o Secure Boot sem o Lanzaboote, 
  # você pode usar sbctl manualmente, mas é mais complexo.
  # Por ora, deixe o Secure Boot desligado na BIOS.
}

{ config, pkgs, lib, ... }: {
  
  boot.loader = {
    systemd-boot.enable = lib.mkForce true;
    efi.canTouchEfiVariables = true;
  };

  };
}

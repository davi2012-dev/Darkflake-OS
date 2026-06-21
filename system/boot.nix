{ config, pkgs, lib, ... }: {

  boot.loader = {
    systemd-boot.enable = lib.mkForce false;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
  };

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
    autoGenerateKeys.enable = true;
    autoEnrollKeys.enable = true;
  };

  # --- CONFIGURAÇÃO DE EMULAÇÃO (ARM E POWERPC) ---
  boot.binfmt = {
    emulatedSystems = [ "aarch64-linux" "armv7l-linux" "powerpc64le-linux" ];
    addEmulatedSystemsToNixSandbox = true;
    preferStaticEmulators = true;
  };

  boot.bootspec.enableValidation = true;
  boot.plymouth.enable = true;
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
  boot.initrd.systemd.enable = true;
  boot.hardwareScan = true;
  boot.tmp = {
    cleanOnBoot = true;
    useTmpfs = true;
    tmpfsSize = "50%";
  };
}

{ config, pkgs, lib, inputs, ... }: {

  boot.loader = {
    systemd-boot.enable = lib.mkForce false; 
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
  };

  # --- SECURE BOOT (LANZABOOTE) ---
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
    autoGenerateKeys.enable = true;
    autoEnrollKeys.enable = true;
  };

  # --- CONFIGURAÇÃO DO INITRD (SYSTEMD NO BOOT) ---
  boot.initrd = {
    enable = true;
    systemd = {
      enable = true; 
      tpm2.enable = true;
      tpm2.pcrphases.enable = true;
    };
    includeDefaultModules = true;
    verbose = false;
  };

  # --- CONFIGURAÇÃO DE EMULAÇÃO (ARM E POWERPC) ---
  boot.binfmt = {
    emulatedSystems = [ "aarch64-linux" "armv7l-linux" "powerpc64le-linux" ];
    addEmulatedSystemsToNixSandbox = true;
    preferStaticEmulators = true;
  };

  # --- TEMA DO PLYMOUTH (ANIMADO VIA FLAKE) ---
  boot.plymouth = {
    enable = true;
    theme = "kartoza";
    themePackages = [
      inputs.kartoza-plymouth-theme.packages.${pkgs.system}.default
    ];
  };

  # --- OUTRAS CONFIGURAÇÕES DO SISTEMA ---
  systemd.shutdownRamfs.enable = true;
  boot.bootspec.enableValidation = true;
  boot.consoleLogLevel = 0;
  boot.hardwareScan = true;
  
  # Gerenciamento avançado de arquivos temporários na RAM (Performance)
  boot.tmp = {
    cleanOnBoot = true;
    useTmpfs = true;
    tmpfsSize = "50%";
    tmpfsHugeMemoryPages = "within_size";
  };
}

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
    compressorArgs = [ "-1" "--threads=0" ];
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
    emulatedSystems = [ "aarch64-linux" "armv7l-linux" "powerpc64le-linux" "powerpc64-linux" "riscv64-linux" "s390x-linux"  "mips64el-linux"  "mipsel-linux"  "i686-linux"  "riscv32-linux" ];
    addEmulatedSystemsToNixSandbox = true;
    preferStaticEmulators = true;
  };

  # --- TEMA DO PLYMOUTH (ANIMADO VIA FLAKE) ---
  boot.plymouth = {
    enable = true;
    theme = "nixos";
    themePackages = [
      inputs.nixos-plymouth-theme.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };

  # --- OUTRAS CONFIGURAÇÕES DO SISTEMA ---
  systemd.shutdownRamfs.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;
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

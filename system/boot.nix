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
    compressor = "zstd";
    compressorArgs = [ "-1" "--threads=0" ];
    systemd = {
      enable = true;
      tpm2.enable = true;
      tpm2.pcrphases.enable = true;
    };
    includeDefaultModules = true;
    verbose = false;
  };
  # --- CONFIGURAÇÃO DE EMULAÇÃO ---
  boot.binfmt = {
    emulatedSystems = [ "aarch64-linux" "armv7l-linux" "powerpc64le-linux" "powerpc64-linux" "riscv64-linux" "s390x-linux" "mips64el-linux" "mipsel-linux" "i686-linux" "riscv32-linux" ];
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
  systemd.coredump.enable = false;
  boot.bootspec.enableValidation = true;
  boot.consoleLogLevel = 0;
  boot.hardwareScan = true;

  # Gerenciamento avançado de arquivos temporários na RAM
  boot.tmp = {
    cleanOnBoot = true;
    useTmpfs = true;
    tmpfsSize = "50%";
  };
  # ========== SONS DE INICIALIZAÇÃO E DESLIGAMENTO ==========
  systemd.services = {
    boot-sound = {
      enable = true;
      description = "Som de inicialização";
      wants = [ "sound.target" ];
      after = [ "sound.target" ];
      before = [ "plymouth-quit.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.alsa-utils}/bin/aplay -D hw:0,0 ${./sounds/startup.wav}";
        RemainAfterExit = false;
        TimeoutStartSec = 5;
      };
    };
    shutdown-sound = {
      enable = true;
      description = "Som de desligamento";
      wants = [ "sound.target" ];
      after = [ "sound.target" ];
      before = [ "plymouth-shutdown.service" "shutdown.target" "reboot.target" "halt.target" ];
      wantedBy = [ "shutdown.target" "reboot.target" "halt.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.alsa-utils}/bin/aplay -D hw:0,0 ${./sounds/shutdown.wav}";
        RemainAfterExit = true;
        TimeoutStartSec = 5;
      };
    };
  };
}

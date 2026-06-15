{ config, pkgs, lib, ... }: {

  boot.loader = {
    systemd-boot.enable = lib.mkForce false;
    efi.canTouchEfiVariables = true;
  };

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
    autoGenerateKeys.enable = true;
    autoEnrollKeys.enable = true;
  };

  # ⚠️ LINHA OBRIGATÓRIA PARA O XEN (do PR #387)
  boot.bootspec.extensions."org.xenproject.bootspec.v1".vmlinux = "${config.system.build.kernel.dev}/vmlinux";

  boot.plymouth.enable = true;
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
  boot.hardwareScan = true;
  boot.tmp = {
    cleanOnBoot = true;
    useTmpfs = true;
    tmpfsSize = "50%";
  };
}

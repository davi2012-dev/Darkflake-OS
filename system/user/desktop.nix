{ config, pkgs, ... }:

{
  # --- Servidor Gráfico e Display Manager ---
  services.xserver.enable = true;
  services.displayManager.plasma-login-manager.enable = true;

  # --- Ambiente de Desktop ---
  services.desktopManager.plasma6.enable = true;

  # --- Otimizações de Hardware para AMD GPU ---
  hardware.amdgpu = {
    opencl.enable = true;
    overdrive.enable = true;
  };

  # --- Gerenciamento Dinâmico de CPU ---
  services.auto-cpufreq = {
    enable = true;
    settings = {
      charger = {
        governor = "performance";
        turbo = "auto";
      };
      battery = {
        governor = "powersave";
        turbo = "never";
      };
    };
  };

  # --- Monitoramento de Saúde dos Discos ---
  services.smartd = {
    enable = true;
    autodetect = true;
    defaults.monitored = "-a -o on -S on -s (S/../.././02|L/../../7/04) -W 4,45,55";
  };

  services.nvme-rs = {
    enable = true;
    settings = {
      check_interval_secs = 3600;
      thresholds = {
        temp_warning = 70;
        wear_warning = 85;
      };
    };
  };

  # --- Serviços do Sistema e Integração ---
  services.libinput.enable = true;
  services.blueman.enable = true;
  services.sysstat.enable = true;
  services.collectd.enable = true;
  services.thermald.enable = true; # Mantido para o seu processador Intel atual
  services.fstrim.enable = true;
  services.upower.enable = true;
  programs.fuse.enable = true;
  services.playerctld.enable = true;
  programs.dconf.enable = true;
  services.xscreensaver.enable = true;
  services.irqbalance.enable = true;                
  security.rtkit.enable = true;
  security.polkit.enable = true;
  security.chromiumSuidSandbox.enable = true;
 
  services.hardware.openrgb.enable = true;
  programs.cpu-energy-meter.enable = true;
  programs.coolercontrol.enable = true;

  services.tailscale.enable = true;
  programs.feedbackd.enable = true;
  programs.mouse-actions.enable = true;
  programs.mouse-actions.autorun = true;
  programs.librepods.enable = true;                  
  services.spice-vdagentd.enable = true;
  nixowos.enable = true;
  security.nixsecauditor.enable = true;

  services.earlyoom = {
    enable = true;
    freeMemThreshold = 10;
    freeMemKillThreshold = 5;
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # --- Otimização de Perfis com Tuned ---
  services.tuned = {
    enable = true;
    ppdSupport = true; # Integração com o seletor de energia do Plasma 6
  };

  powerManagement = {
    enable = true;
    powertop.enable = true; 
  };

  # --- Portais XDG para KDE ---
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
    config.common.default = [ "kde" ];
  };
}

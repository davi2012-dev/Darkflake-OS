{ config, pkgs, ... }:

{
  # --- Servidor Gráfico e Display Manager ---
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.plasma-login-manager.enable = true;

  # ---  Ambiente de Desktop (KDE Plasma 6) ---
  services.desktopManager.plasma6.enable = true;

  # --- 3. Otimizações de Hardware para AMD GPU ---
  hardware.amdgpu = {
    opencl.enable = true;
    overdrive.enable = true;
  };

  # --- Monitoramento de Saúde dos Discos (SATA) ---
  services.smartd = {
    enable = true;
    autodetect = true;
    defaults.monitored = "-a -o on -S on -s (S/../.././02|L/../../7/04) -W 4,45,55";
  };

  # ---  Serviços do Sistema e Integração ---
  services.libinput.enable = true;
  services.swapspace.enable = true;
  services.blueman.enable = true;
  services.fstrim.enable = true;
  services.upower.enable = true;
  programs.fuse.enable = true;
  services.playerctld.enable = true;
  programs.dconf.enable = true;
  services.xscreensaver.enable = true;
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

  services.earlyoom = {
    enable = true;
    freeMemThreshold = 10;
    freeMemKillThreshold = 5;
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  powerManagement = {
    enable = true;
    powertop.enable = true;
    cpuFreqGovernor = "schedutil";
  };

  # --- Portais XDG para KDE ---
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
    config.common.default = [ "kde" ];
  };
}

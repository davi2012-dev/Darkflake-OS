{ config, pkgs, ... }:

{
  # --- 1. Servidor Gráfico e Display Manager ---
  services.xserver.enable = true;
  services.displayManager.cosmic-greeter.enable = true;

  # --- 2. Ambiente de Desktop (COSMIC) ---
  services.desktopManager.cosmic.enable = true;
  services.desktopManager.cosmic.xwayland.enable = true;

  # --- 3. Otimizações de Hardware para AMD GPU ---
  hardware.amdgpu = {
    opencl.enable = true;
    overdrive.enable = true; 
  };

  # --- 4. Serviços do Sistema e Integração ---
  services.libinput.enable = true;
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

  # --- 5. Gerenciamento de Energia ---
  powerManagement = {
    enable = true;
    powertop.enable = true;
    cpuFreqGovernor = "schedutil";
  };

  # --- 6. Portais XDG (COSMIC) ---
  xdg.portal = {
    enable = true;
    extraPortals = [ pkg.xdg-desktop-portal-cosmic];
    config.common.default = [ "cosmic" ];
  };
}

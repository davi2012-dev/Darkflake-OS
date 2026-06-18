{ config, pkgs, ... }: {

  # --- 1. Servidor Gráfico e Display Manager ---
  services.xserver.enable = true;

  # Display Manager
  services.displayManager.plasma-login-manager.enable = true;

  # --- 2. Ambiente de Desktop (Plasma 6) ---
  services.desktopManager.plasma6.enable = true;

  # --- 3. Serviços do Sistema ---
  services.libinput.enable = true;
  services.blueman.enable = true;
  services.fstrim.enable = true;
  services.upower.enable = true;
  programs.fuse.enable = true;
  services.xscreensaver.enable = true;
  appstream.enable = true;
  security.rtkit.enable = true;
  security.polkit.enable = true;
  services.hardware.openrgb.enable = true;

  security.chromiumSuidSandbox.enable = true;
  services.tailscale.enable = true;
  programs.feedbackd.enable = true;
  programs.cpu-energy-meter.enable = true;
  services.earlyoom.enable = true;
  services.earlyoom.freeMemThreshold = 10;
  services.earlyoom.freeMemKillThreshold = 5;
  programs.mouse-actions.enable = true;
  programs.mouse-actions.autorun = true;
  programs.librepods.enable = true;
  services.spice-vdagentd.enable = true;

  programs.coolercontrol.enable = true;
  nixowos.enable = true;

  # Agente GPG
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # --- 4. Gerenciamento de Energia ---
  powerManagement = {
    enable = true;
    powertop.enable = true;
    cpuFreqGovernor = "schedutil";
  };

  # --- 5. Portais XDG ---
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
    config.common.default = [ "kde" ];
  };
}

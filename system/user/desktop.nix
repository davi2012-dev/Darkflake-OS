{ config, pkgs, ... }:

{
  # --- 1. Servidor Gráfico e Display Manager ---
  services.xserver.enable = true;
  # Display Manager customizado do seu setup
  services.displayManager.plasma-login-manager.enable = true;

  # --- 2. Ambiente de Desktop (Plasma 6) ---
  services.desktopManager.plasma6.enable = true;

  # --- 3. Otimizações de Hardware para AMD GPU ---
  hardware.amdgpu = {
    # Ativa o suporte OpenCL usando a pilha moderna do ROCm
    opencl.enable = true;
    overdrive.enable = true; 
  };

  # --- 4. Serviços do Sistema e Integração ---
  services.libinput.enable = true;
  services.blueman.enable = true;             # Gerenciador de Bluetooth gráfico
  services.fstrim.enable = true;              # Coleta de lixo/otimização automática para SSDs
  services.upower.enable = true;              # Estatísticas de bateria e energia de periféricos
  programs.fuse.enable = true;                # Essencial para AppImages/Flatpaks montarem partições
  services.xscreensaver.enable = true;
  
  # Segurança e Sandboxing
  security.rtkit.enable = true;               # Prioridade de tempo real para o áudio (PipeWire)
  security.polkit.enable = true;              # Elevação de privilégios gráfica
  security.chromiumSuidSandbox.enable = true;

  # Ferramentas de Hardware e Monitoramento
  services.hardware.openrgb.enable = true;    # Controle de iluminação RGB
  programs.cpu-energy-meter.enable = true;    # Telemetria de consumo da CPU Intel
  programs.coolercontrol.enable = true;       # Controle avançado de curvas de fans/ventoinhas
  
  # Rede e Utilidades
  services.tailscale.enable = true;           # Orquestrador de rede mesh VPN
  programs.feedbackd.enable = true;
  programs.mouse-actions.enable = true;       # Gestos e mapeamento do mouse
  programs.mouse-actions.autorun = true;
  programs.librepods.enable = true;
  services.spice-vdagentd.enable = true;      # Integração se rodar dentro de VM

  # Customização Temática do seu ecossistema
  nixowos.enable = true;                      # Ativa o tema customizado

  # Daemon de Memória (Evita congelamentos do sistema se a RAM esgotar)
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 10;
    freeMemKillThreshold = 5;
  };

  # Agente GPG com suporte a chaves SSH
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # --- 5. Gerenciamento de Energia ---
  powerManagement = {
    enable = true;
    powertop.enable = true;
    cpuFreqGovernor = "schedutil";            # Governador inteligente
  };

  # --- 6. Portais XDG ---
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
    config.common.default = [ "kde" ];
  };
}

{ config, pkgs, ... }: {

  # --- 1. Desativar Módulos Inúteis / Perigosos ---
  hardware.bluetooth.disabledPlugins = [ "network" "hostname" ];

  # --- 2. Hardware Bluetooth (Performance Máxima + Segurança) ---
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    
    settings = {
      General = {
        Enable = "Source,Sink,Media"; 
        Experimental = true;
        FastConnectable = true;
        Class = "0xFFE100";     
        MultiProfile = "multiple"; 
        KernelExperimental = "6fbaf188-05e0-496a-9885-d6ddfdb4e03e,330859bc-7506-492d-9370-9a6f0614037f";
        
        DiscoverableTimeout = 0; 
        PairableTimeout = 0;     
        
        SecureConnectionsOnly = "true"; 
        JustWorksRepairing = "never";    
        Privacy = "device";              
      };
      Policy = {
        AutoEnable = "true"; 
      };
    };
  };

  # Driver de alta performance para controles de Xbox e outros
  hardware.xpadneo.enable = true;
  hardware.xone.enable = true;
  hardware.i2c.enable  = true;
  hardware.uinput.enable = true;

  # --- 3. Regras do Udev para Controles (Acesso Direto sem Root) ---
  services.udev.packages = [ pkgs.game-devices-udev-rules ];
  services.udev.extraRules = ''
  # --- Regras para controles (jogos) ---
  SUBSYSTEMS=="usb", TAG+="uaccess"
  KERNEL=="hidraw*", TAG+="uaccess"
  KERNEL=="uinput", SUBSYSTEM=="misc", TAG+="uaccess", OPTIONS+="static_node=uinput"

  # Xbox 360
  SUBSYSTEM=="usb", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="028e", TAG+="uaccess"
  SUBSYSTEM=="usb", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="0719", TAG+="uaccess"

  # Xbox One / Series
  SUBSYSTEM=="usb", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="02ea", TAG+="uaccess"
  SUBSYSTEM=="usb", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="0b12", TAG+="uaccess"

  # PlayStation 4 e 5
  SUBSYSTEM=="usb", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="05c4", TAG+="uaccess"
  SUBSYSTEM=="usb", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="09cc", TAG+="uaccess"
  SUBSYSTEM=="usb", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ce6", TAG+="uaccess"

  # 8BitDo
  SUBSYSTEM=="usb", ATTRS{idVendor}=="2dc8", ATTRS{idProduct}=="310b", TAG+="uaccess"
  SUBSYSTEM=="usb", ATTRS{idVendor}=="2dc8", ATTRS{idProduct}=="6012", TAG+="uaccess"

  # --- Regra para ADIOS (scheduler de I/O) ---
  ACTION=="add|change", KERNEL=="sd*|nvme*|mmcblk*", ATTR{queue/rotational}=="0", \
    TEST{queue/scheduler}=="1", ATTR{queue/scheduler}="adios"
'';

  # --- 4. System76 Scheduler (Ajustado Especialmente para o Kernel BORE) ---
  services.system76-scheduler = {
    enable = true;
    # CRÍTICO: Desativa os perfis CFS padrão para o System76 não bagunçar o agendamento do BORE
    settings.cfsProfiles.enable = false; 
    # Mantém apenas o boost focado em processos, garantindo prioridade ao Pipewire
    settings.processScheduler.pipewireBoost.enable = true;
  };

  # --- 5. Configuração do Servidor de Áudio Pipewire ---
  services.pipewire.audio.enable = true;
  services.pipewire.socketActivation = true;
  services.pipewire.raopOpenFirewall = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
    wireplumber.extraConfig = {
      "10-bluez" = {
        "monitor.bluez.properties" = {
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-msbc" = true;   
          "bluez5.enable-hw-volume" = true;
          "bluez5.codecs" = [ "ldac" "aptx_hd" "aptx" "aac" "sbc_xq" ]; 
          "bluez5.roles" = [ "a2dp_sink" "a2dp_source" "headset_head_unit" "headset_audio_gateway" ];
        };
      };
      "11-bluez-policy" = {
        "wireplumber.settings" = {
          "bluetooth.autoswitch-to-headset-profile" = true; 
        };
      };
    };
  };
}

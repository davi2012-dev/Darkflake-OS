{ config, pkgs, ... }: {

  # --- 1. Desativar Módulos Inúteis / Perigosos ---
  # "network" mata os perfis PAN (Personal Area Network) e DUN (Dial-Up Networking).
  # Sem eles, o BlueZ é incapaz de criar interfaces de rede (como bnep0) ou encapsular tráfego HTTP/IP.
  hardware.bluetooth.disabledPlugins = [ "network" "hostname" ];

  # --- 2. Hardware Bluetooth (Performance Máxima + Segurança) ---
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    
    settings = {
      General = {
        # Mantém apenas Áudio e Mídia. Controles usam HID direto que o Udev gerencia.
        Enable = "Source,Sink,Media"; 
        Experimental = true;
        FastConnectable = true; # Seu estado de alerta instantâneo mantido
        Class = "0xFFE100";     
        MultiProfile = "multiple"; 
        KernelExperimental = "6fbaf188-05e0-496a-9885-d6ddfdb4e03e,330859bc-7506-492d-9370-9a6f0614037f";
        
        # Mantidos em 0 (Anti-Preguiça) conforme o seu plano original
        DiscoverableTimeout = 0; 
        PairableTimeout = 0;     
        
        # Suas travas aéreas de criptografia originais
        SecureConnectionsOnly = "true"; 
        JustWorksRepairing = "never";    
        Privacy = "device";              
      };
      Policy = {
        AutoEnable = "true"; 
      };
    };
  };

  # Driver de alta performance para controles de Xbox
  hardware.xpadneo.enable = true;
  hardware.xone.enable = true;
  hardware.i2c.enable  = true;
  # --- 3. Regras do Udev para Controles (Acesso Direto sem Root) ---
  services.udev.packages = [ pkgs.game-devices-udev-rules ];
  services.udev.extraRules = ''
    SUBSYSTEMS=="usb", TAG+="uaccess"
    KERNEL=="hidraw*", TAG+="uaccess"
    KERNEL=="uinput", SUBSYSTEM=="misc", TAG+="uaccess", OPTIONS+="static_node=uinput"

    # Xbox 360
    SUBSYSTEM=="usb", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="028e", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="0719", TAG+="uaccess"
    
    # Xbox One / Series
    SUBSYSTEM=="usb", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="02ea", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="0b12", TAG+="uaccess"

    # PlayStation 4 e 5 (DualShock 4 / DualSense)
    SUBSYSTEM=="usb", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="05c4", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="09cc", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ce6", TAG+="uaccess"

    # 8BitDo
    SUBSYSTEM=="usb", ATTRS{idVendor}=="2dc8", ATTRS{idProduct}=="310b", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="2dc8", ATTRS{idProduct}=="6012", TAG+="uaccess"
  '';

  # --- 4. Configuração do Servidor de Áudio Pipewire ---
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

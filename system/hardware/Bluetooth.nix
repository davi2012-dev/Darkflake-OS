{ config, pkgs, ... }: {

  # --- 1. Desativar Módulos Inúteis / Perigosos ---
  # Bloqueia rede/HTTP via Bluetooth e esconde o nome real do PC na busca pública
  hardware.bluetooth.disabledPlugins = [ "network" "hostname" ];

  # --- 2. Hardware Bluetooth (Performance Máxima + Segurança) ---
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    
    settings = {
      General = {
        # Perfis básicos ativos (Removido o Socket genérico por segurança)
        Enable = "Source,Sink,Media"; 
        Experimental = true;
        FastConnectable = true; # Estado de alerta para pareamento instantâneo
        Class = "0xFFE100";     # Ativa todos os recursos de serviços principais
        MultiProfile = "multiple"; # Gerencia controles e fones juntos sem travar
        KernelExperimental = "6fbaf188-05e0-496a-9885-d6ddfdb4e03e,330859bc-7506-492d-9370-9a6f0614037f";
        
        # --- Anti-Preguiça ---
        DiscoverableTimeout = 0; # Nunca desiste de buscar dispositivos sozinho
        PairableTimeout = 0;     # Mantém a permissão de pareamento sempre pronta
        
        # --- Blindagem contra Ataques Aéreos ---
        SecureConnectionsOnly = "true"; # Exige criptografia AES forte (bloqueia interceptação)
        JustWorksRepairing = "never";    # Impede ataques que forçam re-pareamento invisível
        Privacy = "device";             # Rotaciona o endereço MAC para evitar rastreamento físico
      };
      Policy = {
        AutoEnable = "true"; # Garante o chip ligado e ativo após boot
      };
    };
  };

  # Driver de alta performance para controles de Xbox
  hardware.xpadneo.enable = true;

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
          "bluez5.codecs" = [ "ldac" "aptx_hd" "aptx" "aac" "sbc_xq" ]; # Codecs de Alta Fidelidade
          "bluez5.roles" = [ "a2dp_sink" "a2dp_source" "headset_head_unit" "headset_audio_gateway" ];
        };
      };
      "11-bluez-policy" = {
        "wireplumber.settings" = {
          "bluetooth.autoswitch-to-headset-profile" = true; # Ativa microfone inteligente em chamadas
        };
      };
    };
  };
}

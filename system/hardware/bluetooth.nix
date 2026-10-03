{ config, pkgs, ... }: {

  hardware.bluetooth.disabledPlugins = [
    "network"
    "hostname"
  ];

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
        KernelExperimental = ''
          6fbaf188-05e0-496a-9885-d6ddfdb4e03e,
          330859bc-7506-492d-9370-9a6f0614037f,
          a6695ace-ee7f-4fb9-881a-5fac66c629af,
          00002bcb-0000-1000-8000-00805f9b34fb,
          00002bc9-0000-1000-8000-00805f9b34fb,
          15c0a148-c273-11ea-b3de-0242ac130004,
          671b10b5-42c0-4696-9227-eb28d1b049d6,
          d4992530-b9ec-469f-ab01-6c481c47da1c
        '';
        DiscoverableTimeout = 0;
        PairableTimeout = 0;
        SecureConnectionsOnly = "true";
        JustWorksRepairing = "never";
        Privacy = "device";
        UserspaceHID = true;
        AudioLatency = "100";
        RemoteNameRequestRetryDelay = "100";
        PageTimeout = "32768";
        MinAdvertisementLength = "8";
        MaxAdvertisementLength = "31";
      };
      Policy = {
        AutoEnable = "true";
        ReconnectUUIDs = "0000110b-0000-1000-8000-00805f9b34fb";
        ReconnectAttempts = "7";
        ReconnectIntervals = "1,2,4,8,16,32,64";
      };
    };
  };

  hardware.xpadneo.enable = true;
  hardware.xone.enable = true;
  hardware.i2c.enable = true;
  hardware.uinput.enable = true;

  # Combined and cleaned up udev rules
  services.udev.packages = [ pkgs.game-devices-udev-rules ];
  services.udev.extraRules = ''
    SUBSYSTEMS=="usb", TAG+="uaccess"
    KERNEL=="hidraw*", TAG+="uaccess"
    KERNEL=="uinput", SUBSYSTEM=="misc", TAG+="uaccess", OPTIONS+="static_node=uinput"

    # Controller rules
    SUBSYSTEM=="usb", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="028e", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="0719", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="02ea", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="0b12", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="0b13", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="02fd", TAG+="uaccess"

    SUBSYSTEM=="usb", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="05c4", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="09cc", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ce6", TAG+="uaccess"

    SUBSYSTEM=="usb", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="2009", TAG+="uaccess"

    SUBSYSTEM=="usb", ATTRS{idVendor}=="2dc8", ATTRS{idProduct}=="310b", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="2dc8", ATTRS{idProduct}=="6012", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="2dc8", ATTRS{idProduct}=="6013", TAG+="uaccess"

    # I/O Scheduler for Non-rotational storage (SSDs/NVMe)
    ACTION=="add|change", KERNEL=="sd*|nvme*|mmcblk*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="none"

    # Nintendo Switch Pro Controller over USB
    KERNEL=="hidraw*", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="2009", MODE="0666", TAG+="uaccess"

    # Nintendo Switch Pro Controller over Bluetooth
    KERNEL=="hidraw*", KERNELS=="*057E:2009*", MODE="0666", TAG+="uaccess"

    # Xbox One Controller over USB
    KERNEL=="hidraw*", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="02ea", MODE="0666", TAG+="uaccess"
    KERNEL=="hidraw*", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="02dd", MODE="0666", TAG+="uaccess"

    # Xbox Series X|S Controller
    KERNEL=="hidraw*", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="0b20", MODE="0666", TAG+="uaccess"

    # Disable DualSense touchpad as mouse
    ACTION=="add|change", ATTRS{name}=="Sony Interactive Entertainment DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
    ACTION=="add|change", ATTRS{name}=="DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"

    # Generic fallback for controllers
    SUBSYSTEM=="input", ATTRS{name}=="*Controller*", MODE="0666", TAG+="uaccess"
    SUBSYSTEM=="input", ATTRS{name}=="*Gamepad*", MODE="0666", TAG+="uaccess"
  '';

  services.system76-scheduler = {
    enable = true;
    settings.cfsProfiles.enable = false;
    settings.processScheduler.pipewireBoost.enable = true;
  };

  services.pipewire = {
    enable = true;
    audio.enable = true;
    socketActivation = true;
    raopOpenFirewall = true;
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
          "bluez5.codecs" = [
            "ldac"
            "aptx_hd"
            "aptx"
            "aac"
            "sbc_xq"
          ];
          "bluez5.roles" = [
            "a2dp_sink"
            "a2dp_source"
            "headset_head_unit"
            "headset_audio_gateway"
          ];
          "bluez5.auto-connect" = [ "hfp_hf" "hfp_ag" "a2dp_sink" ];
        };
      };
      "11-bluez-policy" = {
        "wireplumber.settings" = {
          "bluetooth.autoswitch-to-headset-profile" = true;
          "bluetooth.autoconnect-on-power-on" = true;
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [
    blueman
    bluez-alsa
    pavucontrol
    lf
  ];
}

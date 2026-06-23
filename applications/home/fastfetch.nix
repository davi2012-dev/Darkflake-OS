{
  programs.fastfetch = {
    enable = true;
    settings = {
      display = {
        separator = " ";
        constants = [
          "" # {$1}
          "" # {$2}
          "" # {$3}
          "" # {$4}
          "" # {$5}
          "" # {$6}
          "" # {$7}
          "" # {$8}
          "" # {$9}
          "" # {$10}
          "┌──────" # {$11}
          "───────" # {$12}
          "──────┐" # {$13}
        ];
        percent = {
          type = 9;
          color = {
            green = "#a6e3a1";
            yellow = "#fab387";
            red = "#f38ba8";
          };
        };
      };

      modules = [
        "break"
        {
          type = "version";
          color = {
            keys = "";
          };
          key = "{$4}                󱐋󱐋 Fastfetch ";
          format = "{$6}{2}";
        }
        {
         type = "custom";
         format = "{$1}{$11}{$2}{$12}{$3}{$12}{$4}{$12}{$5}{$12}{$6}{$12}{$7}{$12}{$8}{$12}{$9}{$12}{$10}{$13} 󰍹  ハードウェア";
        }
        {
          type = "chassis";
          key = "{$2}├ 󰡪 Chassis  ";
        }
        {
           type = "command";
           key = "{$8}├ 󰋽 Hostname ";
           text = "hostname 2>/dev/null || echo 'desconhecido'";
        }
        {
          type = "board";
          key =  "{$2}├ 󱔼 Board ";
        }
        {
          type = "tpm";
          key = "{$9}├ 󰌆 TPM ";
        }
        {
          type = "cpu";
          key =  "{$3}├  CPU ";
        }
        {
          type = "gpu";
          key =  "{$4}├ 󰾲 GPU ";
        }
        {
          type = "display";
          key =  "{$5}├ 󰍹 Display ";
        }
        {
          type = "sound";
          key =  "{$6}├  Sound ";
        }
        {
          type = "battery";
          key =  "{$6}├ 󰢟 Battery   ";
          format = "{manufacturer} {model-name} ({capacity})";
        }
        {
          type = "memory";
          key = "{$7}├  Memory ";
          percent = {
            type = 3;
            green = 30;
            yellow = 70;
          };
        }
        {
          type = "swap";
          key = "{$8}├ 󰯍 Swap ";
          percent = {
            type = 3;
            green = 30;
            yellow = 70;
          };
        }
        {
          type = "disk";
          key = "{$9}├  NixOS ";
          folders = [ "/" ];
          percent = {
            type = 3;
            green = 30;
            yellow = 70;
          };
        }
        {
          type = "disk";
          key = "{$10}└  Home ";
          folders = [ "/home" ];
          percent = {
            type = 3;
            green = 30;
            yellow = 70;
          };
        }
        {
          type = "disk";
          key = "{$10}└  Guix ";
          folders = [ "/gnu/store" ];
          percent = {
            type = 3;
            green = 30;
            yellow = 70;
        };
        }
        {
         type = "custom";
         format = "{$10}{$11}{$9}{$12}{$8}{$12}{$7}{$12}{$6}{$12}{$5}{$12}{$4}{$12}{$3}{$12}{$2}{$12}{$1}{$13}   ソフトウェア";
        }
        {
          type = "os";
          key =  "{$10}├  Distro ";
          format = "{name} {build-id} ({codename}) {arch}";
        }
        {
          type = "command";
          key = "{$8}├  Hypervisor";
          text = "systemd-detect-virt 2>/dev/null";
        }
        {
          type = "kernel";
          key =  "{$10}├  Kernel ";
        }
        {
          type = "command";
          key = "{$8}├ 󰿃 License ";
          text = "if [ $(cat /proc/sys/kernel/tainted 2>/dev/null) -eq 0 ]; then echo '100% GPL'; else echo 'Tainted (não-GPL)'; fi";
        }
        {
          type = "bios";
          key =  "{$9}├ 󰚗 BIOS ";
        }
        {
          type = "command";
          key = "{$8}├ 󰒅 Secure Boot";
          text = "bootctl status 2>/dev/null | grep 'Secure Boot' | awk '{print $3}' || echo 'N/A'";
        }
        {
          type = "bootmgr";
          key = "{$9}├ 󰚗 Bootmgr ";
        }
        {
          type = "command";
          key = "{$8}├  󰗼 Init ";
          text = "if ps -p 1 -o comm= | grep -q systemd; then echo \"systemd ($(systemd --version | head -1 | awk '{print $2}'))\"; else echo 'desconhecido'; fi";
        }
        {
          type = "packages";
          key =  "{$9}├ 󰏖 Packages  ";
        }
        {
          type = "command";
          key = "{$8}├  AppArmor ";
          text = "aa-status --enabled 2>/dev/null && echo \"Ativo ($(aa-status | grep -c 'profiles' | head -1) perfis)\" || echo 'Inativo'";
        }
        {
          type = "Processes";
          key =  "{$9}├ 󰑮 Processes ";
        }
        {
          type = "shell";
          key =  "{$8}├  Shell ";
        }
        {
          type = "terminal";
          key =  "{$7}├  Terminal ";
        }
        {
          type = "terminalfont";
          key =  "{$6}├ 󰛖 Term Font ";
        }
        {
          type = "de";
          key =  "{$5}├  Desktop Environment ";
        }
        {
          type = "lm";
          key =  "{$4}├ 󰧨 Login ";
        }
        {
          type = "wm";
          key =  "{$3}├  Window Managers ";
        }
        {
          type = "wmtheme";
          key =  "{$2}├ 󰉼 Theme ";
        }
        {
          type = "font";
          key =  "{$2}├ 󰛖 Font ";
        }
        {
          type = "opengl";
          key =  "{$1}├ 󰆧 OpenGL ";
        }
        {
          type = "vulkan";
          key =  "{$1}└ 󰈸 Vulkan ";
        }
        {
          type = "opencl";
          key = "{$1}├ 󰆧 OpenCL ";
          format = "{1}";
        }
        {
         type = "custom";
         format = "{$1}{$11}{$2}{$12}{$3}{$12}{$4}{$12}{$5}{$12}{$6}{$12}{$7}{$12}{$8}{$12}{$9}{$12}{$10}{$13}   セツゾクセイ";
        }
        {
          type = "bluetooth";
          key = "{$1}├ 󰂱 Bluetooth ";
          format = "{1} - {4}";
        }
        {
          type = "bluetoothradio";
          key = "{$1}├ 󰂯 BT Radio ";
          format = "{5}";
        }
        {
          type = "wifi";
          key = "{$2}├  WiFi ";
          format = "{4} - {7} - {13} GHz - {10}";
          showErrors = "never";
        }
        {
          type = "command";
          key =  "├ 󰖪 TCP Congestion Control";
          text = "sysctl -n net.ipv4.tcp_congestion_control";
        }
        {
          type = "dns";
          key = "{$4}├ 󱦂 DNS ";
        }
        {
          type = "localip";
          key = "{$6}├ 󰩟 Local IP ";
          format = "{1} - {3}";
          showMac = true;
        }
        {
          type = "publicip";
          key = "{$8}└ 󰩠 Public IP ";
          format = "{1} - {2}";
        }
        {
          type = "command";
          key = "{$7}├ 󰩟 Portas ";
          text = "ss -tuln | grep -E 'LISTEN|UDP' | awk '{print $5}' | cut -d: -f2 | sort -n | uniq | head -10 | tr '\n' ' ' | sed 's/ $//' || echo 'nenhuma'";
        }
        {
          type = "command";
          key = "{$7}├ 󰩟 Placas ";
          text = "ip -4 -br addr | grep -v 'lo\\|virbr\\|docker\\|veth\\|br-' | awk '{printf \"%s: %s  \", $1, $3}' | sed 's/  $//' || echo 'nenhuma'";
        }
        {
          type = "command";
          key = "{$7}├ 󰩟 Gateway ";
          text = "ip route | grep default | awk '{print $3}' || echo 'nenhum'";
        }
        {
          type = "command";
          key = "{$8}├ 󰉫 Firewall ";
          text = "if systemctl is-active --quiet nftables; then echo 'Active (nftables)'; else echo 'Inactive'; fi";
        }
        {
         type = "custom";
         format = "{$10}{$11}{$9}{$12}{$8}{$12}{$7}{$12}{$6}{$12}{$5}{$12}{$4}{$12}{$3}{$12}{$2}{$12}{$1}{$13}   ジカン";
        }
        {
          type = "DateTime";
          key = "{$10}├ 󰥔 Date/Time ";
        }
        {
          key = "{$8}├  OS Age ";
          type = "disk";
          folders = "/";
          format = "{create-time:10} ({days} days)";
        }
        {
          type = "uptime";
          key = "{$6}└  Uptime ";
        }
        {
          type = "command";
          key = "{$7}├ 󰖐 Clima ";
          text = "curl -s 'wttr.in/Ituberá?format=%t+%C+%l' 2>/dev/null | sed 's/+/ /g' || echo '--'";
        }
        {
           type = "custom";
           format = "{$10}{$11}{$9}{$12}{$8}{$12}{$7}{$12}{$6}{$12}{$5}{$12}{$4}{$12}{$3}{$12}{$2}{$12}{$1}{$13}  リヨウシャ";
        }
        {
           type = "users";
           key = "{$4}├ 󰋽 user ";
           format = "{1}@{2} - {3}";
        }
        {
           type = "wallpaper";
           key = "{$6}├ 󰸉 wallpaper ";
           format = "{1}";
        }
        {
          type = "command";
          key =  "├ 󰝚  Now Playing ";
          text = "playerctl metadata --format '{{artist}} - {{title}}' 2>/dev/null || echo 'nenhuma'";
        }
        {
          type = "custom";
          format = "                󱄅 󱄅 󱄅 󱄅 󱄅 󱄅 󱄅 󱄅 󱄅 󱄅";
        }
      ];
    };
  };
}

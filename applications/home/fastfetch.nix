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
            green = "#51bcfe";
            yellow = "#abff4a";
            red = "#ff8f45";
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
          type = "host";
          key = "{$1}├   PC        ";
        }
        {
          type = "board";
          key = "{$2}├ 󱔼  Board     ";
        }
        {
          type = "cpu";
          key = "{$3}├   CPU        ";
        }
        {
          type = "gpu";
          key = "{$4}├ 󰾲  GPU        ";
        }
        {
          type = "display";
          key = "{$5}├ 󰍹  Display   ";
        }
        {
          type = "sound";
          key = "{$6}├   Sound     ";
        }
        {
          type = "battery";
          key = "{$6}├ 󰢟  Battery   ";
          format = "{manufacturer} {model-name} ({capacity})";
        }
        {
          type = "memory";
          key = "{$7}├   Memory    ";
          percent = {
            type = 3;
            green = 30;
            yellow = 70;
          };
        }
        {
          type = "swap";
          key = "{$8}├ 󰯍  Swap      ";
          percent = {
            type = 3;
            green = 30;
            yellow = 70;
          };
        }
        {
          type = "disk";
          key = "{$9}├   NixOS     ";
          folders = [ "/" ];
          percent = {
            type = 3;
            green = 30;
            yellow = 70;
          };
        }
        {
          type = "disk";
          key = "{$10}└   Home      ";
          folders = [ "/home" ];
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
          key = "{$10}├   Distro    ";
          format = "{name} {build-id} ({codename}) {arch}";
        }
        {
          type = "kernel";
          key = "{$10}├   Kernel   ";
        }
        {
          type = "bios";
          key = "{$9}├ 󰚗  BIOS      ";
        }
        {
          type = "packages";
          key = "{$9}├ 󰏖  Packages  ";
        }
        {
          type = "Processes";
          key = "{$9}├ 󰑮  Processes ";
        }
        {
          type = "shell";
          key = "{$8}├   Shell     ";
        }
        {
          type = "terminal";
          key = "{$7}├   Terminal  ";
        }
        {
          type = "custom";
          key = "├ 󰖪  TCP CC   ";
          command = "sysctl -n net.ipv4.tcp_congestion_control";
          format = "{1}";
        }
        {
          type = "custom";
          key = "├ 󰧨  Scheduler";
          command = "uname -r | grep -o 'cachyos-bore' || echo 'outro'";
          format = "{1}";
        }
        {
          type = "terminalfont";
          key = "{$6}├ 󰛖  Term Font ";
        }
        {
          type = "custom";
          key = "{$10}├ 󰝚  Música   ";
          command = "playerctl metadata --format '{{artist}} - {{title}}' 2>/dev/null || echo 'nenhuma'";
          format = "{1}";
        }
        {
          type = "de";
          key = "{$5}├   DE        ";
        }
        {
          type = "lm";
          key = "{$4}├ 󰧨  Login     ";
        }
        {
          type = "wm";
          key = "{$3}├   Window    ";
        }
        {
          type = "wmtheme";
          key = "{$2}├ 󰉼  Theme     ";
        }
        {
          type = "font";
          key = "{$2}├ 󰛖  Font      ";
        }
        {
          type = "opengl";
          key = "{$1}├ 󰆧  OpenGL    ";
        }
        {
          type = "vulkan";
          key = "{$1}└ 󰈸  Vulkan    ";
        }
        {
          type = "custom";
          format = "{$1}{$11}{$2}{$12}{$3}{$12}{$4}{$12}{$5}{$12}{$6}{$12}{$7}{$12}{$8}{$12}{$9}{$12}{$10}{$13}   セツゾクセイ";
        }
        {
          type = "bluetooth";
          key = "{$1}├ 󰂱  Bluetooth ";
          format = "{1} - {4}";
        }
        {
          type = "bluetoothradio";
          key = "{$1}├ 󰂯  BT Radio  ";
          format = "{5}";
        }
        {
          type = "wifi";
          key = "{$2}├   WiFi      ";
          format = "{4} - {7} - {13} GHz - {10}";
          showErrors = "never";
        }
        {
          type = "dns";
          key = "{$4}├ 󱦂  DNS       ";
        }
        {
          type = "localip";
          key = "{$6}├ 󰩟  Local IP  ";
          format = "{1} - {3}";
          showMac = true;
        }
        {
          type = "publicip";
          key = "{$8}└ 󰩠  Public IP ";
          format = "{1} - {2}";
        }
        {
          type = "custom";
          format = "{$10}{$11}{$9}{$12}{$8}{$12}{$7}{$12}{$6}{$12}{$5}{$12}{$4}{$12}{$3}{$12}{$2}{$12}{$1}{$13}   ジカン";
        }
        {
          type = "DateTime";
          key = "{$10}├ 󰥔  Date/Time ";
        }
        {
          key = "{$8}├   OS Age    ";
          type = "disk";
          folders = "/";
          format = "{create-time:10} ({days} days)";
        }
        {
          type = "uptime";
          key = "{$6}└   Uptime    ";
        }
        {
          type = "custom";
          format = "                󱄅 󱄅 󱄅 󱄅 󱄅 󱄅 󱄅 󱄅 󱄅 󱄅";
        }
      ];
    };
  };
}

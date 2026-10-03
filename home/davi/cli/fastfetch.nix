{
  programs.fastfetch = {
    enable = true;
    settings = {
      display = {
        separator = " ";
      };

      modules = [
        "break"
        {
          type = "version";
          key = "                󱐋󱐋 Fastfetch ";
          format = "{2}";
        }

        # --- Bloco HARDWARE (Cyan) ---
        {
          type = "custom";
          key = "╭─────────────────────────────────── Hardware ─────────────────────────────────────╮";
          keyColor = "cyan";
        }
        {
          type = "chassis";
          key = "│ ├ 󰇅 Chassis  ";
          keyColor = "cyan";
        }
        {
          type = "command";
          key = "│ ├ 󰋽 Hostname ";
          text = "hostname 2>/dev/null || echo 'desconhecido'";
          keyColor = "cyan";
        }
        {
          type = "board";
          key = "│ ├ 󱔼 Board ";
          keyColor = "cyan";
        }
        {
          type = "tpm";
          key = "│ ├ 󰌆 TPM ";
          keyColor = "cyan";
        }
        {
          type = "cpu";
          key = "│ ├  CPU ";
          keyColor = "cyan";
        }
        {
          type = "gpu";
          key = "│ ├ 󰾲 GPU ";
          keyColor = "cyan";
        }
        {
          type = "display";
          key = "│ ├ 󰍹  Display ";
          keyColor = "cyan";
        }
        {
          type = "sound";
          key = "│ ├   Sound ";
          keyColor = "cyan";
        }
        {
          type = "battery";
          key = "│ ├ 󰢟 Battery   ";
          format = "{manufacturer} {model-name} ({capacity})";
          keyColor = "cyan";
        }
        {
          type = "memory";
          key = "│ ├  Memory ";
          keyColor = "cyan";
          percent = {
            type = 3;
            green = 30;
            yellow = 70;
          };
        }
        {
          type = "swap";
          key = "│ ├ 󰯍 Swap ";
          keyColor = "cyan";
          percent = {
            type = 3;
            green = 30;
            yellow = 70;
          };
        }
        {
          type = "disk";
          key = "│ ├  NixOS ";
          folders = [ "/" ];
          keyColor = "cyan";
          percent = {
            type = 3;
            green = 30;
            yellow = 70;
          };
        }
        {
          type = "disk";
          key = "│ ├  Home ";
          folders = [ "/home" ];
          keyColor = "cyan";
          percent = {
            type = 3;
            green = 30;
            yellow = 70;
          };
        }
        {
          type = "disk";
          key = "│ └  Guix ";
          folders = [ "/gnu/store" ];
          keyColor = "cyan";
          percent = {
            type = 3;
            green = 30;
            yellow = 70;
          };
        }
        {
          type = "custom";
          key = "╰──────────────────────────────────────────────────────────────────────────────────╯";
          keyColor = "cyan";
        }
        "break"

        # --- Bloco SOFTWARE (Magenta/Mauve) ---
        {
          type = "custom";
          key = "╭─────────────────────────────────── Software ─────────────────────────────────────╮";
          keyColor = "magenta";
        }
        {
          type = "bios";
          key = "│ ├ 󰚗 BIOS ";
          keyColor = "magenta";
        }
        {
          type = "command";
          key = "│ ├  Secure Boot";
          text = "bootctl status 2>/dev/null | grep 'Secure Boot' | awk '{print $3}' || echo 'N/A'";
          keyColor = "magenta";
        }
        {
          type = "bootmgr";
          key = "│ ├ 󰚗 Bootmgr ";
          keyColor = "magenta";
        }
        {
          type = "command";
          key = "│ ├  Hypervisor";
          text = "systemd-detect-virt 2>/dev/null";
          keyColor = "magenta";
        }
        {
          type = "os";
          key = "│ ├  Distro ";
          format = "{name} {build-id} ({codename}) {arch}";
          keyColor = "magenta";
        }
        {
          type = "kernel";
          key = "│ ├  Kernel ";
          keyColor = "magenta";
        }
        {
          type = "command";
          key = "│ ├ 󰿃 License ";
          text = "if [ $(cat /proc/sys/kernel/tainted 2>/dev/null) -eq 0 ]; then echo '100% GPL'; else echo 'Tainted (não-GPL)'; fi";
          keyColor = "magenta";
        }
        {
          type = "command";
          key = "│ ├ 󰗼 Init ";
          text = "if ps -p 1 -o comm= | grep -q systemd; then echo \"systemd ($(systemd --version | head -1 | awk '{print $2}'))\"; else echo 'desconhecido'; fi";
          keyColor = "magenta";
        }
        {
          type = "command";
          key = "│ ├  AppArmor ";
          text = "aa-status --enabled 2>/dev/null && echo \"Ativo ($(aa-status | grep -c 'profiles' | head -1) perfis)\" || echo 'Inativo'";
          keyColor = "magenta";
        }
        {
          type = "Processes";
          key = "│ ├ 󰑮 Processes ";
          keyColor = "magenta";
        }
        {
          type = "terminal";
          key = "│ ├  Terminal ";
          keyColor = "magenta";
        }
        {
          type = "terminalfont";
          key = "│ ├ 󰛖 Term Font ";
          keyColor = "magenta";
        }
        {
          type = "shell";
          key = "│ ├  Shell ";
          keyColor = "magenta";
        }
        {
          type = "lm";
          key = "│ ├ 󰧨 Login ";
          keyColor = "magenta";
        }
        {
          type = "command";
          key = "│ ├  Xorg ";
          text = "X -version 2>&1 | grep 'X Server' | awk '{print $3}' || echo 'N/A'";
          keyColor = "magenta";
        }
        {
          type = "opengl";
          key = "│ ├ 󰆧 OpenGL ";
          keyColor = "magenta";
        }
        {
          type = "vulkan";
          key = "│ ├ 󰈸 Vulkan ";
          keyColor = "magenta";
        }
        {
          type = "opencl";
          key = "│ ├ 󰆧 OpenCL ";
          format = "{1}";
          keyColor = "magenta";
        }
        {
          type = "wm";
          key = "│ ├  Window Managers ";
          keyColor = "magenta";
        }
        {
          type = "de";
          key = "│ ├  Desktop Environment ";
          keyColor = "magenta";
        }
        {
          type = "wmtheme";
          key = "│ ├ 󰉼 Theme ";
          keyColor = "magenta";
        }
        {
          type = "font";
          key = "│ ╰ 󰛖 Font ";
          keyColor = "magenta";
        }
        {
          type = "custom";
          key = "╰──────────────────────────────────────────────────────────────────────────────────╯";
          keyColor = "magenta";
        }
        "break"

        # --- Bloco NETWORKS (Green) ---
        {
          type = "custom";
          key = "╭─────────────────────────────────── Networks ─────────────────────────────────────╮";
          keyColor = "green";
        }
        {
          type = "bluetoothradio";
          key = "│ ├ 󰂯 BT Radio ";
          format = "{5}";
          keyColor = "green";
        }
        {
          type = "bluetooth";
          key = "│ ├ 󰂱 Bluetooth ";
          format = "{1} - {4}";
          keyColor = "green";
        }
        {
          type = "wifi";
          key = "│ ├  WiFi ";
          format = "{4} - {7} - {13} GHz - {10}";
          showErrors = "never";
          keyColor = "green";
        }
        {
          type = "command";
          key = "│ ├ 󰩟 Placas ";
          text = "ip -4 -br addr | grep -v 'lo\\|virbr\\|docker\\|veth\\|br-' | awk '{printf \"%s: %s  \", $1, $3}' | sed 's/  $//' || echo 'nenhuma'";
          keyColor = "green";
        }
        {
          type = "localip";
          key = "│ ├ 󰩟 Local IP ";
          format = "{1} - {3}";
          showMac = true;
          keyColor = "green";
        }
        {
          type = "command";
          key = "│ ├ 󰩟 Gateway ";
          text = "ip route | grep default | awk '{print $3}' || echo 'nenhum'";
          keyColor = "green";
        }
        {
          type = "dns";
          key = "│ ├ 󱦂 DNS ";
          keyColor = "green";
        }
        {
          type = "command";
          key = "│ ╰ 󱨑 Firewall ";
          text = "if systemctl is-active --quiet nftables; then echo 'Active (nftables)'; else echo 'Inactive'; fi";
          keyColor = "green";
        }
        {
          type = "custom";
          key = "╰──────────────────────────────────────────────────────────────────────────────────╯";
          keyColor = "green";
        }
        "break"

        # --- Bloco TIME (Red/Flamingo) ---
        {
          type = "custom";
          key = "╭───────────────────────────────────── Time ───────────────────────────────────────╮";
          keyColor = "red";
        }
        {
          type = "uptime";
          key = "│ ├  Uptime ";
          keyColor = "red";
        }
        {
          type = "DateTime";
          key = "│ ├ 󰥔 Date/Time ";
          keyColor = "red";
        }
        {
          key = "│ ├  OS Age ";
          type = "disk";
          folders = "/";
          format = "{create-time:10} ({days} days)";
          keyColor = "red";
        }
        {
          type = "command";
          key = "│ ╰ 󰖐 Clima ";
          text = "curl -s 'wttr.in/Ituberá?format=%t+%C+%l' 2>/dev/null | sed 's/+/ /g' || echo '--'";
          keyColor = "red";
        }
        {
          type = "custom";
          key = "╰──────────────────────────────────────────────────────────────────────────────────╯";
          keyColor = "red";
        }
        "break"

        # --- Bloco USER (Blue/Lavender) ---
        {
          type = "custom";
          key = "╭───────────────────────────────────── User ───────────────────────────────────────╮";
          keyColor = "blue";
        }
        {
          type = "users";
          key = "│ ├ 󰋽 user ";
          format = "{1}@{2} - {3}";
          keyColor = "blue";
        }
        {
          type = "wallpaper";
          key = "│ ├ 󰸉 wallpaper ";
          format = "{1}";
          keyColor = "blue";
        }
        {
          type = "command";
          key = "│ ╰ 󰝚  Now Playing ";
          text = "playerctl metadata --format '{{artist}} - {{title}}' 2>/dev/null || echo 'nenhuma'";
          keyColor = "blue";
        }
        {
          type = "custom";
          key = "╰──────────────────────────────────────────────────────────────────────────────────╯";
          keyColor = "blue";
        }
        "break"

        # --- Bloco DEVELOPMENT & LANGUAGES (Yellow/Peach) ---
        {
          type = "custom";
          key = "╭────────────────────────────────── Development ───────────────────────────────────╮";
          keyColor = "yellow";
        }
        {
          type = "command";
          key = "│ ├  Go ";
          text = "go version 2>/dev/null | awk '{print $3}' || echo 'N/A'";
          keyColor = "yellow";
        }
        {
          type = "command";
          key = "│ ├  Python ";
          text = "python3 --version 2>/dev/null | awk '{print $2}' || echo 'N/A'";
          keyColor = "yellow";
        }
        {
          type = "command";
          key = "│ ├  C++ ";
          text = "(g++ -dumpfullversion -dumpversion || clang++ --version | head -n1 | awk '{print $3}') 2>/dev/null || echo 'N/A'";
          keyColor = "yellow";
        }
        {
          type = "command";
          key = "│ ├  Java ";
          text = "java -version 2>&1 | head -n1 | sed 's/.*version \"//;s/\".*//' || javac -version 2>&1 | awk '{print $2}' || echo 'N/A'";
          keyColor = "yellow";
        }
        {
          type = "command";
          key = "│ ├   Rust ";
          text = "rustc --version 2>/dev/null | awk '{print $2}' || echo 'N/A'";
          keyColor = "yellow";
        }
        {
          type = "command";
          key = "│ ├   Nix ";
          text = "nix-env --version 2>/dev/null | awk '{print $3}' || echo 'N/A'";
          keyColor = "yellow";
        }
        {
          type = "command";
          key = "│ ├   Editor ";
          text = "echo $EDITOR || echo 'nano'";
          keyColor = "yellow";
        }
        {
          type = "command";
          key = "│ ├  Git ";
          text = "git --version 2>/dev/null | awk '{print $3}' || echo 'N/A'";
          keyColor = "yellow";
        }
        {
          type = "command";
          key = "│ ╰ 󰋜 Interface ";
          text = "echo 'Adwaita Sans (11pt) [GTK2/3/4]'";
          keyColor = "yellow";
        }
        {
          type = "custom";
          key = "╰──────────────────────────────────────────────────────────────────────────────────╯";
          keyColor = "yellow";
        }
        "break"
        {
          type = "custom";
          format = "                󱄅 󱄅 󱄅 󱄅 󱄅 󱄅 󱄅 󱄅 󱄅 󱄅";
        }
      ];
    };
  };
}

{ config, pkgs, lib, ... }:

let
  justfileContent = pkgs.writeText "justfile" ''
    default:
        @echo "Uso: njust hmx"
        @echo "     njust latesh"
        @echo "     njust get-emudeck [status|install|uninstall]"
        @echo "     njust bios-info"
        @echo "     njust benchmark"

    hmx:
        curl -fsSL https://get.hmx.dev | bash

    latesh:
        ssh -4 late.sh

    # Show BIOS info (Bazzite-like style)
    bios-info:
        #!/usr/bin/bash
        echo "Manufacturer: \$(cat /sys/class/dmi/id/board_vendor 2>/dev/null || echo 'Unknown')"
        echo "Product Name: \$(cat /sys/class/dmi/id/board_name 2>/dev/null || echo 'Unknown')"
        echo "Version:      \$(cat /sys/class/dmi/id/bios_version 2>/dev/null || echo 'Unknown')"
        echo "Release Date: \$(cat /sys/class/dmi/id/bios_date 2>/dev/null || echo 'Unknown')"

    # Run a one minute system benchmark
    benchmark:
        #!/usr/bin/bash
        echo 'Running a 1 minute benchmark ...'
        cd /tmp && stress-ng --matrix 0 -t 1m --times

    alias install-emudeck := get-emudeck

    # Install EmuDeck (https://www.emudeck.com/). Options: status | install | uninstall
    get-emudeck ACTION="":
        #!/usr/bin/bash
        set -eo pipefail
        get_status_token() {
            if compgen -G "$HOME/Applications/*EmuDeck*.AppImage" > /dev/null; then
                echo "install"
            elif find "$HOME/.local/share/applications" -maxdepth 1 -type f -name "*.desktop" \
                \( -iname "*emudeck*" -o -iname "*org.emudeck.com*" \) 2>/dev/null | grep -q .; then
                echo "install"
            else
                echo "uninstall"
            fi
        }
        get_current_status() {
            if [[ "$(get_status_token)" == "install" ]]; then
                echo "Installed"
            else
                echo "Not Installed"
            fi
        }
        install_emudeck() {
            remote_appimage_url="$(
                curl -s https://api.github.com/repos/EmuDeck/emudeck-electron/releases/latest | \
                jq -r ".assets[] | select(.name | test(\".*AppImage\")) | .browser_download_url"
            )"
            njust _install_appimage_file "$remote_appimage_url"
        }
        uninstall_emudeck() {
            find "$HOME/Applications" -maxdepth 1 -type f -name "*EmuDeck*.AppImage" -delete 2>/dev/null || true
            find "$HOME/.local/share/applications" -maxdepth 1 -type f \
                \( -iname "*emudeck*.desktop" -o -iname "*org.emudeck.com*.desktop" \) \
                -delete 2>/dev/null || true
            find "$HOME/.local/share/icons" -type f \
                \( -iname "*emudeck*" -o -iname "*org.emudeck.com*" \) \
                -delete 2>/dev/null || true
            echo "EmuDeck has been uninstalled."
        }
        OPTION="{{ ACTION }}"
        if [[ "$OPTION" == "status" ]]; then
            get_status_token
            exit 0
        elif [[ "$OPTION" == "install" ]]; then
            install_emudeck
            exit 0
        elif [[ "$OPTION" == "uninstall" ]]; then
            uninstall_emudeck
            exit 0
        elif [[ -z "$OPTION" ]]; then
            current_status=$(get_current_status)
            echo -e "\e[1mEmuDeck\e[0m"
            echo "Current status: $current_status"
            OPTION=$(ugum choose "Install" "Uninstall" "Exit without changes")
            case "$OPTION" in
                "Install")
                    install_emudeck
                    ;;
                "Uninstall")
                    uninstall_emudeck
                    ;;
                *)
                    echo "No changes made."
                    ;;
            esac
            exit 0
        fi
  '';

  njust = pkgs.symlinkJoin {
    name = "njust";
    paths = [ pkgs.just pkgs.tmux pkgs.bash ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      mkdir -p $out/bin
      makeWrapper ${pkgs.just}/bin/just $out/bin/njust \
        --add-flags "--justfile ${justfileContent}" \
        --add-flags "--shell ${pkgs.bash}/bin/bash" \
        --set PATH ${lib.makeBinPath [
          pkgs.just
          pkgs.tmux
          pkgs.curl
          pkgs.bash
          pkgs.coreutils
          pkgs.openssh
          pkgs.gawk
          pkgs.gnused
          pkgs.gnugrep
          pkgs.gzip
          pkgs.jq        
          pkgs.findutils  
          pkgs.gum      
          pkgs.stress-ng
        ]}
    '';
  };
in {
  environment.systemPackages = [ njust ];
}

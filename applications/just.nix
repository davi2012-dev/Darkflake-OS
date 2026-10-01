{ config, pkgs, lib, ... }:

let
  justfileContent = pkgs.writeText "justfile" ''
    default:
        @echo "Uso: njust hmx"
        @echo "     njust latesh"
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
          pkgs.findutils
          pkgs.stress-ng
        ]}
    '';
  };
in {
  environment.systemPackages = [ njust ];
}

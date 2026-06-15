{ config, pkgs, lib, ... }:

let
  justfileContent = pkgs.writeText "justfile" ''
    default:
        @echo "Uso: njust hmx"
        @echo "       njust --help"

    hmx:
        curl -fsSL https://get.hmx.dev | bash
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
          pkgs.gawk
          pkgs.gnused
          pkgs.gnugrep
          pkgs.gzip
        ]}
    '';
  };
in {
  environment.systemPackages = [ njust ];
}

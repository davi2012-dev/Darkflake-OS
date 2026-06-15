{ config, pkgs, lib, ... }:

let
  justfileContent = pkgs.writeText "justfile" ''
    # Receita padrão (não faz nada perigoso)
    default:
        @echo "Uso: njust hmx"
        @echo "       njust --help"

    # Instala o Honeymux (só com argumento hmx)
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
        --set PATH ${lib.makeBinPath [ pkgs.tmux pkgs.curl pkgs.bash ]}
    '';
  };
in {
  environment.systemPackages = [ njust ];
}

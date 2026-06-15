{ config, pkgs, lib, ... }:

let
  justfileContent = pkgs.writeText "justfile" ''
    hmx:
        curl -fsSL https://get.hmx.dev | bash
  '';
  njust = pkgs.symlinkJoin {
    name = "njust";
    paths = [ pkgs.just pkgs.tmux ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      mkdir -p $out/bin
      makeWrapper ${pkgs.just}/bin/just $out/bin/njust \
        --add-flags "--justfile ${justfileContent}" \
        --set PATH ${lib.makeBinPath [ pkgs.tmux pkgs.curl ]}
    '';
  };
in {
  # Isso é o que um módulo NixOS deve retornar
  environment.systemPackages = [ njust ];
}

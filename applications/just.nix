{ pkgs, lib, ... }@args:
let
  justfileContent = pkgs.writeText "justfile" ''
    hmx:
        curl -fsSL https://get.hmx.dev | bash
  '';
in
pkgs.symlinkJoin {
  name = "njust";
  paths = [ pkgs.just pkgs.tmux ];
  buildInputs = [ pkgs.makeWrapper ];
  postBuild = ''
    mkdir -p $out/bin
    makeWrapper ${pkgs.just}/bin/just $out/bin/njust \
      --add-flags "--justfile ${justfileContent}" \
      --set PATH ${lib.makeBinPath [ pkgs.tmux pkgs.curl ]}
  '';
}

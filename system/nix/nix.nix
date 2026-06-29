{ config, pkgs, lib, inputs, ... }: {

  # ---  NH: O Assistente Moderno ---
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 7d --keep 3";
    flake = "/etc/nixos";
  };

  # ---  Nix Config & Performance ---
  nix.channel.enable = false;
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" "ca-derivations" "pipe-operators" "recursive-nix" "dynamic-derivations" "fetch-tree"  ];
    auto-optimise-store = true;
    substituters = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org" 
      "https://attic.xuyh0120.win/lantian"
      "https://chaotic-nyx.cachix.org"
      "https://noctalia.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
    max-substitution-jobs = 20;
    builders-use-substitutes = true;
    sandbox = true;
    cores = 0; 
    max-jobs = "auto";
    http-connections = 50;
    connect-timeout = 5;
  };

  # --- Nix-LD (Suporte a Binários Externos) ---
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc zlib fuse3 openssl icu nss curl expat glibc 
  ];

  environment.systemPackages = with pkgs; [
    nvd nix-output-monitor
    git gcc gnumake pkg-config
    (python3.withPackages (ps: with ps; [ pip virtualenv ]))
    rustup
  ];

  nixpkgs.config.allowUnfree = true;
  programs.ccache.enable = true;
  programs.nixbit.enable = true;
  programs.nixbit.repository = "https://github.com/davi2012-dev/Darkflake-OS";
  programs.nix-required-mounts.enable = true;

  # ---  GNU Guix Integration ---
  services.guix = {
    enable = true;
    gc.enable = true;
    publish = {
      enable = true;
      generateKeyPair = true;
    };
    substituters.urls = [
      "https://ci.guix.gnu.org"
      "https://bordeaux.guix.gnu.org"
      "https://berlin.guix.gnu.org"
    ];
  };
}

{ config, pkgs, lib, inputs, ... }: {

  # --- 1. Auto Upgrade ---
  system.autoUpgrade = {
    enable = true;
    dates = "daily";
    flake = "/etc/nixos#Darkflake";
    operation = "boot";
    flags = [
      "--update-input" "nixpkgs"
      "--update-input" "chaotic"
      "--update-input" "home-manager"
      "--update-input" "nixpkgs-unstable"
      "--update-input" "nix-cachyos-kernel" 
      "-L"
    ];
  };

  # --- 2. NH ---
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 7d --keep 3";
    flake = "/etc/nixos";
  };

  # --- 3. Nix Config & Performance (ATUALIZADO) ---
  nix.channel.enable = false;
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" "ca-derivations" "pipe-operators" "recursive-nix" "dynamic-derivations" "fetch-tree" ];
    auto-optimise-store = true;
    substituters = [
      "https://cache.nixos.org/"
      "https://nixpkgs-x86-64-v3.cachix.org"
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org" 
      "https://chaotic-nyx.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nixpkgs-x86-64-v3.cachix.org-1:4NbB5kY+Fz4z6L+OE34r3Qk3y1xxk1u4e+FYsCmPgl4="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
    ];
    max-substitution-jobs = 20;
    builders-use-substitutes = true;
    sandbox = true;
    cores = 0; 
    max-jobs = "auto";
    http-connections = 50;
    connect-timeout = 5;
    system-features = [ "gccarch-x86-64-v3" ];
  };

  # --- 4. FORÇAR x86-64-v3 (NOVO BLOCO) ---
  nixpkgs.hostPlatform = {
    system = "x86_64-linux";
    cpu = "x86-64-v3";
  };

  # --- 5. Demais configs (Nix-LD, Packages, Guix...) ---
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

  # --- 6. GNU Guix Integration ---
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

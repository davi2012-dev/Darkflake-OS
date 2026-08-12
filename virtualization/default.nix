{ config, pkgs, ... }: {
  imports = [
    ./podman.nix
    ./waydroid.nix
    ./lxc.nix
  ];

  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  programs.virt-manager.enable = true;
}

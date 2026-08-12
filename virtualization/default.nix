{ config, pkgs, ... }: {
  imports = [
    ./podman.nix
    ./lxc.nix
  ];

  virtualisation.libvirtd.enable = true;
  virtualisation.waydroid.enable = true;
  virtualisation.waydroid.package = pkgs.waydroid-nftables;
  virtualisation.spiceUSBRedirection.enable = true;
  programs.virt-manager.enable = true;

}

{ config, pkgs, ... }: {
  imports = [
    ./podman.nix
    ./lxc.nix
  ];

  environment.systemPackages = with pkgs; [
    qemu
    virt-viewer
    xz
  ];

  virtualisation.libvirtd.enable = true;
  virtualisation.waydroid.enable = true;
  virtualisation.waydroid.package = pkgs.waydroid-nftables;
  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.libvirtd.qemu.swtpm.enable = true;
  services.spice-vdagentd.enable = true;
  programs.virt-manager.enable = true;

}

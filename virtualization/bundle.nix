{ ... }: {
  imports = [
    ./podman.nix
    ./waydroid.nix
    ./lxc.nix
  ];

  virtualisation.appvm.enable = true;
  virtualisation.appvm.user = "davi";
  virtualisation.vswitch.enable = true;
  virtualisation.vswitch.resetOnStart = false;
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
}

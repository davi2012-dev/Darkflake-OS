{ ... }: {
  imports = [
    ./podman.nix
    ./libvirtd.nix
    ./waydroid.nix
    ./lxc.nix
    ./xem.nix
  ];

  virtualisation.appvm.enable = true;
  virtualisation.appvm.user = "davi";
  virtualisation.vswitch.enable = true;
  virtualisation.vswitch.resetOnStart = false;
}

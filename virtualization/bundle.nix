{ ... }: {
  imports = [
    ./podman.nix
    ./libvirtd.nix
    ./waydroid.nix
  ];

  virtualisation.appvm.enable = true;
  virtualisation.appvm.user = "davi";
}

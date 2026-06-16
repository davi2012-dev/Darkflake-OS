{ ... }: {
  imports = [
    ./podman.nix
    ./libvirtd.nix
    ./waydroid.nix
  ];

  virtualisation.appvm.enable = true;
  virtualisation.appvm.user = "davi";
  virtualisation.vswitch.enable = true;
  virtualisation.vswitch.resetOnStart = false;
  virtualisation.useSecureBoot = true;
  virtualisation.memorySize = 8192;
  virtualisation.writableStore = true;
}

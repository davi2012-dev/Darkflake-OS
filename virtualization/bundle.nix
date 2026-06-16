{ ... }: {
  imports = [
    ./podman.nix
    ./libvirtd.nix
    ./waydroid.nix
    ./home-assistant.nix
    ./qemu.nix
  ];
}

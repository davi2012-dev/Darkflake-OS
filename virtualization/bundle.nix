{ config, pkgs, ... }: {

  imports = [
    ./podman.nix
    ./libvirtd.nix
    ./waydroid.nix
    ./home-assistant.nix
    ./qemu.nix
    ./vswitch.nix
    #./xen.nix
  ];

  virtualisation.nixStore9pCache = "loose";
  virtualisation = {
    graphics = true;
    resolution = { x = 1920; y = 1080; };
    useEFIBoot = true;
    useSecureBoot = true;
    mountHostNixStore = true;
    useHostCerts = true;
    writableStore = true;
    writableStoreUseTmpfs = true;
  };

}

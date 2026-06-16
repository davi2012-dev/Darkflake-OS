{ modulesPath, ... }:

{
  imports = [
    "${modulesPath}/virtualisation/qemu-vm.nix"
    "${modulesPath}/virtualisation/containers.nix"
    "${modulesPath}/virtualisation/libvirtd.nix"
    "${modulesPath}/virtualisation/openvswitch.nix"
  ];
}

{ ... }: {
  imports = [
    ./clamav.nix
    ./tpm.nix
    ./sops.nix
    # apparmor.nix e usbguard.nix ficam fora de propósito (órfãos deliberados)
  ];
}

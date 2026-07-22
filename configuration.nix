{ config, lib, pkgs, inputs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix

    ./system/boot.nix
    ./system/kernel.nix
    ./system/idioma.nix
    ./system/nix/nix.nix
    ./system/user/user.nix
    ./system/user/users.motd.nix
    ./system/user/desktop.nix
    ./system/hardware/Bluetooth.nix
    ./system/hardware/Audio/surround.nix
    ./system/hardware/printing.nix
    ./ai/ollama.nix
    ./system/filesystem/default.nix  
    ./system/network/default.nix     
    ./system/optimization/default.nix
    ./virtualization/bundle.nix
    ./security/default.nix
    ./applications/apps.nix
    ./applications/just.nix
    ./applications/fun.nix       
  ];

  
  system.stateVersion = "25.11"; 
}

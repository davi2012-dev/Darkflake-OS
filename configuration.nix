{ config, lib, pkgs, inputs, ... }:

{
  imports = [ 
    # 1. Configurações de Hardware base (Gerado pelo sistema)
    ./hardware-configuration.nix

    # 2. O Coração do Sistema (Importando as pastas que criamos)
    ./system/boot.nix
    ./system/kernel.nix
    ./system/idioma.nix
    ./system/nix/nix.nix
    ./system/user/user.nix
    ./system/user/users.motd.nix
    ./system/user/desktop.nix
    ./system/hardware/Bluetooth.nix
    ./system/hardware/Audio/surround.nix
    ./system/hardware/Audio/radio.nix
    # 3. Módulos Agrupados (Bundles)
    ./system/filesystem/bundle.nix  
    ./system/network/bundle.nix     
    ./system/optimization/bundle.nix
    ./virtualization/bundle.nix
    ./security/bundle.nix
    # 4. Interface e Aplicativos
    ./applications/apps.nix
    ./applications/just.nix
    ./applications/fun.nix       

  ];

  
  system.stateVersion = "25.11"; 
}

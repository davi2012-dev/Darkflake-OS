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
    ./system/hardware/printing.nix
    ./ai/ollama.nix
    # 3. Módulos Agrupados (Bundles)
    ./system/filesystem/default.nix  
    ./system/network/default.nix     
    ./system/optimization/default.nix
    ./virtualization/bundle.nix
    ./security/default.nix
    # 4. Interface e Aplicativos
    ./applications/apps.nix
    ./applications/just.nix
    ./applications/fun.nix       
  ];

  
  system.stateVersion = "25.11"; 
}

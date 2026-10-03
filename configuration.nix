{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    # --- Hardware / Boot ---
    ./hardware-configuration.nix
    ./system/boot.nix
    ./system/kernel.nix
    ./system/disko.nix

    # --- Sistema base ---
    ./system/idioma.nix
    ./system/nix/default.nix
    ./system/filesystem/default.nix
    ./system/optimization/default.nix

    # --- Usuário ---
    ./system/user/user.nix
    ./system/user/desktop.nix

    # --- Periféricos ---
    ./system/hardware/bluetooth.nix
    ./system/hardware/audio.nix
    ./system/hardware/printing.nix

    # --- Rede ---
    ./system/network/default.nix

    # --- Virtualização ---
    ./system/virtualization/default.nix

    # --- Segurança ---
    ./security/default.nix

    # --- IA ---
    ./system/ai/ollama.nix

    # --- Pacotes e apps ---
    ./system/packages/apps.nix
    ./system/packages/just.nix
    ./system/packages/fun.nix
  ];
}

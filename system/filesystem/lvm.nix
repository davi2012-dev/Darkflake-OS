{ config, lib, pkgs, ... }:

{
  # 1. Ativa o suporte ao LVM2 no sistema
  services.lvm.enable = true;

  # 2. Garante que o Kernel consiga montar volumes LVM logo no boot
  # Isso evita que o sistema pare no "initrd" se o seu disco for LVM
  boot.managedResources.logicalVolumes = true;

  # 3. Ferramentas essenciais para gerenciar seus volumes no terminal
  environment.systemPackages = with pkgs; [
    lvm2
    partition-manager # Interface gráfica (opcional, remova se quiser só terminal)
  ];

  # 4. Exemplo de hibernação (Opcional)
  # Se você usa uma partição swap dentro do LVM para hibernar o PC:
  # boot.resumeDevice = "/dev/mapper/vg0-swap";
}

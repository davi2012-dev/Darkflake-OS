{ config, pkgs, ... }: {

  virtualisation.nixStore9pCache = "loose";
  virtualisation.qemu = {
    # 1. Performance Bruta e Aceleração de Hardware
    forceAccel = true;         # Força o uso do KVM por hardware; se falhar, o build avisa
    diskInterface = "virtio";   # Usa drivers VirtIO para leitura/escrita de disco ultra rápidas
    enableSharedMemory = true; # Compartilhamento eficiente de RAM entre as camadas virtuais
    virtioKeyboard = false;
    # 2. Suporte a Integração (Opcional, mas ajuda muito no monitoramento)
    guestAgent.enable = true;  # Permite que o host se comunique melhor com o agente interno da VM

    # 3. Argumentos Extras do QEMU (Passa o processador real do seu PC para dentro da VM)
    options = [
      "-cpu host"            
    ];
  };
}

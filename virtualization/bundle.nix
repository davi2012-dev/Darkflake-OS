{ config, pkgs, ... }: {

  # ... seus imports permanecem os mesmos (podman, qemu, vswitch, etc.)

  virtualisation = {
    graphics = true;
    resolution = { x = 1920; y = 1080; };

    # Redirecionamento de Hardware via SPICE
    spiceUSBRedirection.enable = true; # <--- Ativa o repasse de pendrives, webcams e celulares USB

    # Inicialização moderna e Segurança
    useEFIBoot = true;
    useSecureBoot = true;
    tpm.enable = true;

    # Otimizações de compartilhamento
    mountHostNixStore = true;
    nixStore9pCache = "loose";
    useHostCerts = true;
    writableStore = true;
    writableStoreUseTmpfs = true;

    appvm = {
      enable = true;
      user = "davi"; 
    };
  };

  environment.systemPackages = with pkgs; [
    bridge-utils
    iptables
    swtpm
    spice-gtk                        # Garante que o cliente gráfico tenha suporte a gerenciar o USB
  ];
}

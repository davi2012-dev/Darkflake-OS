{ config, pkgs, ... }: {

  # 1. Importação dos sub-módulos que isolamos
  imports = [
    ./podman.nix
    ./libvirtd.nix
    ./waydroid.nix
    ./home-assistant.nix
    ./qemu.nix
    ./vswitch.nix
    # ./xen.nix # Comentado, caso queira reativar o Xen depois
  ];
  
  # 2. Configurações Globais de Virtualização da VM
  virtualisation = {
    # Resolução e Tela (Para quando você abrir a interface gráfica da VM)
    graphics = true;
    resolution = { x = 1920; y = 1080; };

    # Inicialização moderna e Firmware
    useEFIBoot = true;
    useSecureBoot = true;

    # Otimizações de compartilhamento com o Host físico
    mountHostNixStore = true;
    nixStore9pCache = "loose";       # Cache de alta performance na RAM para ler o host
    useHostCerts = true;             # Herda os certificados SSL do host (evita erros de rede)
    
    # Comportamento do armazenamento temporário
    writableStore = true;
    writableStoreUseTmpfs = true;    # Grava modificações temporárias do OS direto na RAM

    # Isolamento de aplicativos em modo Sandbox (AppVM) para o seu usuário
    appvm = {
      enable = true;
      user = "davi"; 
    };
  };

  # 3. Pacotes globais necessários para sustentar essa estrutura
  environment.systemPackages = with pkgs; [
    qemu_kvm
    libvirt
    bridge-utils
    iptables
  ];

}

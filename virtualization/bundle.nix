{ config, pkgs, ... }: {

  # 1. Importação dos sub-módulos isolados
  imports = [
    ./podman.nix
    ./libvirtd.nix
    ./waydroid.nix
    ./home-assistant.nix
    ./qemu.nix
    ./vswitch.nix
    # ./xen.nix 
  ];
  
  # 2. Configurações Globais de Virtualização da VM
  virtualisation = {
    # Resolução e Tela (Para quando abrir a interface gráfica da VM)
    resolution = { x = 1920; y = 1080; };
    spiceUSBRedirection.enable = true;
    # Inicialização moderna, Firmware e Segurança Estilo Hardware Real
    useEFIBoot = true;
    useSecureBoot = true;
    tpm.enable = true;               # Emula o chip TPM virtual (fundamental com o SecureBoot)

    # Otimizações de compartilhamento de arquivos com o Host físico
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

  # 3. Ferramentas utilitárias extras para gerenciamento de redes no terminal
  environment.systemPackages = with pkgs; [
    bridge-utils
    iptables
    swtpm                            # Utilitário para monitorar/interagir com o chip TPM se necessário
  ];

}

{ config, pkgs, lib, ... }:

{
  virtualisation.xen = {
    enable = true;

    # Configuração correta: dom0Resources (não "dom0")
    dom0Resources = {
      memory = 1024;        # Memória inicial (mínimo garantido) = 1 GB
      maxMemory = 4096;     # Máximo que o Dom0 pode crescer = 4 GB
      maxVCPUs = 4;         # Usa todos os 4 núcleos do seu i5-7500
    };
  };

  # Parâmetros adicionais de boot (opcional, mas recomendado para ballooning fino)
  boot.kernelParams = [
    "xen_scrub_pages=0"        # Desativa limpeza agressiva (ajuda ballooning)
    "xen-swiotlb=65536"        # Buffer para DMA, evita travamentos
  ];
}

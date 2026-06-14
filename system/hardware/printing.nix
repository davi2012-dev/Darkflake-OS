{ config, pkgs, ... }: {
  services.printing = {
    enable = true;
    drivers = with pkgs; [ 
      gutenprint             # Drivers de alta qualidade para fotos e impressoras comuns
      gutenprintBin          # Versão binária para mais compatibilidade
      hplip                  # Essencial para HP (inclui scanner)
      hplipWithPlugin        # Drivers HP com plugins proprietários (firmware)
      brlaser                # Melhores drivers para Brother Laser
      brgenml1lpr            # Drivers genéricos Brother
      canon-cups-ufr2        # Impressoras Canon modernas
      epson-escpr            # Impressoras Epson L-series e XP
      splix                  # Impressoras Samsung e Xerox velhas
      foo2zjs                # Impressoras baratas (LaserJet 1018, 1020, etc)
    ];
  };

  # 2. Descoberta Automática 
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };

  # 3. Suporte para Scanners 
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.hplipWithPlugin ];
  };
}

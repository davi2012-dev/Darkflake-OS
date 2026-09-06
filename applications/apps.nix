{ config, pkgs, lib, unstable, ... }: {

  programs.appimage = {
    enable = true;
    binfmt = true;      
  };

  environment.systemPackages = with pkgs; [
    vesktop           
    beeper                
    tor-browser
    gimp              
    inkscape            
    krita             
    dippi             
    cryptomator       
    btop                  
    carapace            
    eza             
    yazi              
    zoxide           
    fzf                
    bluetui
    impala
    wiremix
    bat
    nil
    deadnix
    ripsecrets      
    vscodium 
    ghostty       
    distrobox-tui
    distroshelf       
    gearlever                
    termius
    nixfmt
    statix
    outils              
    stress-ng          
    nicstat            
    gping              
    duf              
    ncdu               
    mission-center     
    winboat
    iredis
    flameshot           
    localsend          
    obsidian            
    bazaar             
    proton-pass
    proton-authenticator
    proton-vpn
    waydroid-helper
    kando
    kdePackages.qtwebsockets
    onlyoffice-desktopeditors          
    unrar
    p7zip

    # === Rust/C Modern CLI ===
    dust              # du visual bonito
    procs             # ps moderno com ports/docker/memoria
    sd                # sed simplificado
    hexyl             # hex viewer colorido
    tokei             # conta linhas de codigo
    hyperfine         # benchmarking rigoroso
    bandwhich         # traffic por processo
    gitui             # git TUI rapido
    git-delta         # diff syntax highlight
    tealdeer          # tldr rapido
    broot             # tree interativo com navigacao
    ouch              # compressao multi-formato
    xh                # curl moderno e bonito
    dogdns            # dig moderno
    watchexec         # executa comando ao alterar ficheiros
    grex              # gera regex de exemplos
    navi              # cheatsheet interativo
    erdtree           # tree com tamanho
  ];

  services.flatpak = {
    enable = true;
    packages = [
      "com.github.tchx84.Flatseal"
      "io.github.flattool.Warehouse"
      "org.vinegarhq.Sober"
      "sh.ppy.osu"
      "com.usebottles.bottles"
      "com.vysp3r.ProtonPlus"
      "app.fotema.Fotema"
      "io.gitlab.metadatacleaner.metadatacleaner"
      "io.github.plrigaux.sysd-manager"
      "de.schmidhuberj.DieBahn"
      "io.github.giantpinkrobots.flatsweep"
      "com.github.johnfactotum.Foliate"
      "dev.deedles.Trayscale"
      "io.github.linx_systems.ClamUI"
      "io.gitlab.theevilskeleton.Upscaler"
    ];
  };
}

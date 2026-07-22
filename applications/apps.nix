{ config, pkgs, lib, unstable, guixpkgs, ... }: {

  # ========== SUPORTE A APPIMAGE ==========
  programs.appimage = {
    enable = true;
    binfmt = true;      
  };

  environment.systemPackages = with pkgs; [
    # --- Internet e Comunicação ---
    vesktop           
    beeper             
    crow-translate     
    tor-browser

    # --- Multimídia e Design ---
    mpv                 
    gimp              
    inkscape            
    krita             
    dippi             
    cryptomator 
    # --- Terminal Moderno (Rust Tools) ---
    fastfetch          
    btop              
    starship       
    carapace            
    eza             
    yazi              
    zoxide           
    fzf              
    television       
    bluetui
    impala
    wiremix
    bat
    nil
    deadnix
    ripsecrets
    amdgpu_top
    # --- Desenvolvimento e Sistema ---
    lazygit          
    vscodium 
    ghostty
    distrobox          
    distrobox-tui
    distroshelf       
    appimage-run
    gearlever         
    topgrade          
    termius
    nixfmt
    statix
    cockpit-machines
    # --- Diagnóstico e Stress ---
    outils              
    stress-ng          
    nicstat            
    gping              
    duf              
    ncdu               
    mission-center     
    winboat
    # --- Utilitários e Organização ---
    iredis
    flameshot           
    localsend          
    obsidian            
    bazaar             
    proton-pass
    proton-authenticator
    proton-vpn
    waydroid-helper
    mcp-nixos
    kando
    kdePackages.qtwebsockets
    # --- Produtividade ---
    onlyoffice-desktopeditors
    zathura            
    unrar
    p7zip
    rclone              
  ];

  # --- Flatpak Config ---
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
      "com.cassidyjames.butler"
      "io.github.giantpinkrobots.flatsweep"
      "com.github.johnfactotum.Foliate"
      "dev.deedles.Trayscale"
      "io.github.linx_systems.ClamUI"
      "io.gitlab.theevilskeleton.Upscaler"
      "runtime/org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/25.08"
      "runtime/org.freedesktop.Platform.VulkanLayer.vkBasalt/x86_64/25.08"
      "runtime/org.freedesktop.Platform.VulkanLayer.OBSVkCapture/x86_64/25.08"
    ];
  };
}

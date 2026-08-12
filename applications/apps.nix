{ config, pkgs, lib, unstable, guixpkgs, ... }: {

  programs.appimage = {
    enable = true;
    binfmt = true;      
  };

  environment.systemPackages = with pkgs; [
    vesktop           
    beeper             
    crow-translate     
    tor-browser
    mpv                 
    gimp              
    inkscape            
    krita             
    dippi             
    cryptomator 
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
    lazygit          
    vscodium 
    ghostty       
    distrobox-tui
    distroshelf       
    appimage-run
    gearlever         
    topgrade          
    termius
    nixfmt
    statix
    cockpit-machines
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

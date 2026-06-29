{ config, pkgs, inputs, unstable, ... }: {

  # ========== SUPORTE A APPIMAGE ==========
  programs.appimage = {
    enable = true;
    binfmt = true;      # Permite executar AppImages como programas normais
  };

  environment.systemPackages = with pkgs; [
    # --- Internet e Comunicação ---
    vesktop             # Discord com melhorias (Vencord)
    beeper              # O app de chat universal moderno
    crow-translate      # Tradutor rápido
    tor-browser

    # --- Multimídia e Design ---
    mpv                 # Player de vídeo minimalista
    gimp                # Editor de imagens
    inkscape            # Vetores
    krita               # Pintura digital
    dippi               # Analisador de densidade de pixels
    cryptomator 
    # --- Terminal Moderno (Rust Tools) ---
    fastfetch           # O substituto do neofetch
    btop               # Monitor de recursos visual
    starship            # O melhor prompt universal
    carapace            # Completions para o shell
    eza                 # O 'ls' do futuro
    yazi                # Gerenciador de arquivos via terminal
    zoxide              # O 'cd' inteligente
    fzf                 # Filtro borrado (fuzzy finder)
    television          # TUI de busca
    bluetui
    impala
    wiremix
    bat
    nil
    deadnix
    ripsecrets
    amdgpu_top
    # --- Desenvolvimento e Sistema ---
    git
    lazygit             # Interface TUI para git
    vscodium 
    ghostty
    distrobox           # Rodar outras distros no terminal
    distrobox-tui
    distroshelf         # Menu para gerenciar suas distroboxes
    appimage-run        # Rodar AppImages fácil (ainda útil como fallback)
    gearlever           # Gerenciar AppImages com interface
    topgrade            # Atualiza TUDO (Nix, Flatpak, Firmware) de uma vez
    termius
    nixfmt
    statix
    cockpit-machines
    # --- Diagnóstico e Stress ---
    outils              # Ferramentas clássicas estilo BSD
    stress-ng           # Stress test de hardware
    nicstat             # Estatísticas de rede
    gping               # Ping com gráfico
    duf                 # Uso de disco visual
    ncdu                # Analisador de uso de disco (TUI)
    mission-center      # Monitor de sistema estilo Windows 11
    winboat
    # --- Utilitários e Organização ---
    iredis
    flameshot           # Screenshots
    localsend           # Transferir arquivos via Wi-Fi
    obsidian            # Suas notas
    bazaar              # Gerenciador de arquivos leve
    proton-pass
    proton-authenticator
    proton-vpn
    waydroid-helper
    mcp-nixos
    kando
    kdePackages.qtwebsockets
    # --- Produtividade ---
    onlyoffice-desktopeditors
    zathura             # Leitor de PDF minimalista
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
      "net.agalwood.Motrix"
      "dev.deedles.Trayscale"
      "io.github.linx_systems.ClamUI"
      "io.gitlab.theevilskeleton.Upscaler"
      "runtime/org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/25.08"
      "runtime/org.freedesktop.Platform.VulkanLayer.vkBasalt/x86_64/25.08"
      "runtime/org.freedesktop.Platform.VulkanLayer.OBSVkCapture/x86_64/25.08"
    ];
  };
}

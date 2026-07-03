{ config, pkgs, inputs, ... }: {

  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  programs.spicetify = {
    enable = true;
    wayland = true;
    experimentalFeatures = true;

    # 1. Temas e Cores (Catppuccin Mocha)
    theme = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system}.themes.catppuccin;
    colorScheme = "mocha";

    # 2. Extensões (Melhorias e Adblock)
    enabledExtensions = with inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system}.extensions; [
      adblockify
      hidePodcasts
      shuffle
      beautifulLyrics
      coverAmbience
      catJamSynced
      keyboardShortcut
      bookmark
      trashbin
      fullAppDisplay
      powerBar
      lastfm
      songStats
      playlistIcons
      autoVolume 
      romajiConvert
      simpleBeautifulLyrics 
      ytVideo 
    ];

    # 3. Custom Apps (Páginas completas)
    enabledCustomApps = with inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system}.apps; [
      marketplace
      ncsVisualizer 
      newReleases
      historyInSidebar
    ];

    # 4. Snippets do Marketplace (Nyan Cat adicionado com sucesso!)
    enabledSnippets = with inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system}.snippets; [
      nyanCatProgressBar        # <--- Barra do Nyan Cat voando no arco-íris! 
      pointer                    # Mantém o cursor de mãozinha nos botões
      roundedNowPlaying          # Cantos arredondados na barra de reprodução
    ];
  };
}
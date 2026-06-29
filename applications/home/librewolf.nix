{ config, pkgs, lib, ... }:

let
  # Configuração do mecanismo de busca (SearXNG )
  searchConfig = pkgs.writeText "search.json.mozlz4" ''
    {
      "version": 6,
      "engines": [
        {
          "_metaData": {
            "alias": "searxng"
          },
          "_name": "SearXNG",
          "_shortName": "searxng",
          "description": "Busca privada via SearXNG",
          "iconURL": "https://search.darkflake.local/static/themes/simple/img/favicon.png",
          "isDefault": true,
          "order": 1,
          "searchForm": "https://search.darkflake.local",
          "searchUrlGetParams": "q={searchTerms}&categories=general&language=pt",
          "suggestUrlGetParams": "q={searchTerms}",
          "type": "application/x-sj"
        }
      ]
    }
  '';

  setupSearch = pkgs.writeShellScriptBin "setup-librewolf-search" ''
    PROFILE_DIR="${config.home.homeDirectory}/.mozilla/librewolf/darkflake"
    mkdir -p "$PROFILE_DIR"
    cp ${searchConfig} "$PROFILE_DIR/search.json.mozlz4"
  '';

  librewolf-wrapped = pkgs.writeShellScriptBin "librewolf" ''
    exec ${pkgs.bubblewrap}/bin/bwrap \
      --unshare-all \
      --share-net \
      --bind /nix /nix \
      --bind /run/user/$(id -u) /run/user/$(id -u) \
      --bind /tmp/.X11-unix /tmp/.X11-unix \
      --bind /dev/dri /dev/dri \
      --dev /dev \
      --proc /proc \
      --tmpfs /tmp \
      --bind "${config.home.homeDirectory}/.mozilla" "${config.home.homeDirectory}/.mozilla" \
      --bind "${config.home.homeDirectory}/Downloads" "${config.home.homeDirectory}/Downloads" \
      --ro-bind /etc /etc \
      --ro-bind /usr /usr \
      --ro-bind /bin /bin \
      --ro-bind /lib /lib \
      --ro-bind /lib64 /lib64 \
      --chdir "${config.home.homeDirectory}" \
      ${pkgs.librewolf}/bin/librewolf "$@"
  '';
in
{
  programs.librewolf = {
    enable = true;
    languagePacks = [ "pt-BR" ];
    policies = {
      DisableTelemetry = true;
      Certificates.ImportEnterpriseRoots = true;
    };
    profiles.darkflake = {
      id = 0;
      isDefault = true;
      name = "Darkflake";
      settings = {
        "webgl.disabled" = false;
        "privacy.resistFingerprinting" = true;
        "privacy.trackingprotection.enabled" = true;
        "identity.fxaccounts.enabled" = true;
        "sidebar.verticalTabs" = true;
        
        # SearXNG como mecanismo de busca padrão
        "browser.search.defaultenginename" = "SearXNG";
        "browser.search.order.1" = "SearXNG";
        "browser.urlbar.placeholderName" = "SearXNG";
        "browser.search.hiddenOneOffs" = "";
        "browser.urlbar.suggest.searches" = true;
      };
    };
  };

  home.packages = [ 
    librewolf-wrapped 
    setupSearch 
  ];

  xdg.desktopEntries.librewolf = {
    name = "LibreWolf";
    exec = "librewolf %U";
    icon = "librewolf";
    type = "Application";
    categories = [ "Network" "WebBrowser" ];
    mimeType = [
      "text/html" "text/xml" "application/xhtml+xml"
      "application/vnd.mozilla.xul+xml" "text/mml"
      "x-scheme-handler/http" "x-scheme-handler/https"
    ];
    settings = {
      StartupNotify = "true";
    };
  };

  # Configura a busca ao ativar o perfil
  home.activation.setupLibreWolfSearch = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD ${setupSearch}/bin/setup-librewolf-search
  '';
}

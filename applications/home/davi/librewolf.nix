{ config, pkgs, lib, ... }:

let
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
        "webgl.disabled" = true;
        "privacy.resistFingerprinting" = false;
        "privacy.trackingprotection.enabled" = true;
        "identity.fxaccounts.enabled" = true;
        "sidebar.verticalTabs" = true;
      };
    };
  };

  home.packages = [ librewolf-wrapped ];

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
}

{ config, pkgs, lib, ... }:

let
  librewolf-wrapped = pkgs.writeShellScriptBin "librewolf" ''
    exec ${pkgs.bubblewrap}/bin/bwrap \
      --unshare-all \
      --share-net \
      --die-with-parent \
      --new-session \
      --ro-bind /nix /nix \
      --ro-bind /etc /etc \
      --ro-bind-try /usr /usr \
      --ro-bind-try /bin /bin \
      --ro-bind-try /lib /lib \
      --ro-bind-try /lib64 /lib64 \
      --bind /run/user/$(id -u) /run/user/$(id -u) \
      --bind /tmp/.X11-unix /tmp/.X11-unix \
      --dev /dev \
      --dev-bind /dev/dri /dev/dri \
      --proc /proc \
      --tmpfs /tmp \
      --bind "${config.home.homeDirectory}/.librewolf" "${config.home.homeDirectory}/.librewolf" \
      --bind "${config.home.homeDirectory}/Downloads" "${config.home.homeDirectory}/Downloads" \
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

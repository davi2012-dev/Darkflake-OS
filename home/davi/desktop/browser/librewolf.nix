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
      DontCheckDefaultBrowser = true;
      DisablePocket = true;
      DisableAppUpdate = true;
      DisableTelemetry = true;
      Certificates.ImportEnterpriseRoots = true;
    };
    
    profiles.darkflake = {
      id = 0;
      isDefault = true;
      name = "Darkflake";
      settings = {
        "security.enable_tls" = true;
        "security.tls.version.min" = 2;
        "security.tls.version.max" = 4;
        "privacy.trackingprotection.fingerprinting.enabled" = true;
        "browser.sessionstore.privacy_level" = 0;
        "browser.newtabpage.activity-stream.enabled" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.selfsupport.url" = "";
        "extensions.abuseReport.enabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "app.shield.optoutstudies.enabled" = false;
        "app.normandy.enabled" = false;
        "extensions.pocket.enabled" = false;
        "dom.disable_window_flip" = true;
        "dom.disable_window_move_resize" = true;
        "browser.formfill.enable" = false;
        "plugin.disable_full_page_plugin_for_types" = "application/pdf,application/fdf,application/xfdf,application/lso,application/lss,application/iqy,application/rqy,application/lsl,application/xlk,application/xls,application/xlt,application/pot,application/pps,application/ppt,application/dos,application/dot,application/wks,application/bat,application/ps,application/eps,application/wch,application/wcm,application/wb1,application/wb3,application/rtf,application/doc,application/mdb,application/mde,application/wbk,application/ad,application/adp";
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
    settings.StartupNotify = "true";
  };
}

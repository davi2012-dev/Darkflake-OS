{ config, pkgs, lib, ... }:

let
  librewolf-sandbox = pkgs.writeShellScriptBin "librewolf-sandbox" ''
    exec ${pkgs.bubblewrap}/bin/bwrap \
      --unshare-all \
      --share-net \
      --bind /nix /nix \
      --bind /run/user/$(id -u) /run/user/$(id -u) \
      --bind /tmp/.X11-unix /tmp/.X11-unix \
      --bind /dev/dri /dev/dri \
      --bind /sys/dev/char /sys/dev/char \
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
      };
    };
  };

  home.packages = [ librewolf-sandbox ];
}

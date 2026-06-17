{ config, pkgs, ... }:

{
  services.caddy = {
  enable = true;
  email = "DaviMigue@proton.me";  # Pode manter, mas não será usado

  virtualHosts = {
    "nextcloud.Darkflake.local" = {
      extraConfig = ''
        tls internal
        reverse_proxy localhost:8085
      '';
    };
    "jellyfin.Darkflake.local" = {
      extraConfig = ''
        tls internal
        reverse_proxy localhost:8096
      '';
    };
    "librechat.Darkflake.local" = {
      extraConfig = ''
        tls internal
        reverse_proxy localhost:3080
      '';
    };
    "homarr.Darkflake.local" = {
      extraConfig = ''
        tls internal
        reverse_proxy localhost:8083
      '';
    };
    "stirling.Darkflake.local" = {
      extraConfig = ''
        tls internal
        reverse_proxy localhost:8089
      '';
    };
    "metube.Darkflake.local" = {
      extraConfig = ''
        tls internal
        reverse_proxy localhost:8081
      '';
    };
    "netdata.Darkflake.local" = {
      extraConfig = ''
        tls internal
        reverse_proxy localhost:19999
      '';
    };
    "ha.Darkflake.local" = {
      extraConfig = ''
        tls internal
        reverse_proxy localhost:8123
      '';
    };
    "portainer.Darkflake.local" = {
      extraConfig = ''
        tls internal
        reverse_proxy localhost:9443 {
          transport http {
            tls_insecure_skip_verify
          }
        }
      '';
    };
  };
};

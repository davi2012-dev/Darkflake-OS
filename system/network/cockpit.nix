{ config, pkgs, lib, ... }: {
  services.cockpit = {
    enable = true;
    settings = {
      WebService = {
        AllowUnencrypted = false;
        Origins = lib.mkForce "https://localhost:9090 https://127.0.0.1:9090";
      };
    };
  };
}

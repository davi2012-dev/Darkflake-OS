{ config, pkgs, ... }:

{
  programs.librewolf = {
    enable = true;
    settings = {
      "webgl.disabled" = false; 
      "privacy.resistFingerprinting" = true;
      "privacy.trackingprotection.enabled" = true;
    };
  };
}

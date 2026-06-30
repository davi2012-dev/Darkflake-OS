{ config, lib, ... }:

{
  sops.secrets."user-davi-hashed-password" = {
    sopsFile = ../secrets.yaml;
  };

  sops.secrets."user-guest-hashed-password" = {
    sopsFile = ../secrets.yaml;
  };
}

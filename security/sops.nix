{ config, lib, ... }:

{
  sops.age.keyFile = "/home/davi/.config/sops/age/keys.txt";
  sops.secrets."user-davi-hashed-password" = {
    sopsFile = ../secrets.yaml;
  };

  sops.secrets."user-guest-hashed-password" = {
    sopsFile = ../secrets.yaml;
  };
}

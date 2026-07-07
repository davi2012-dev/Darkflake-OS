{ config, pkgs, ... }:

{
  # --- 1. Configuração de Usuários ---
  users.users.davi = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "video" "podman" "libvirtd" "gamemode" "wireshark" "scanner" ];
    hashedPasswordFile = config.sops.secrets."user-davi-hashed-password".path;
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOzBpVHAyiVi9K/lYXC4QsIYkbUsSAhrzlF592oXtOyc davi@darkflake"
  };

  users.users.guest = {
    isNormalUser = true;
    description = "Usuario Convidado";
    extraGroups = [ ];
    hashedPasswordFile = config.sops.secrets."user-guest-hashed-password".path;
  };

  # --- 2. Trancando o Nix (Restrição de Acesso) ---
  nix.settings = {
    allowed-users = [ "root" "@wheel" ];
    trusted-users = [ "root" "davi"   ];
  };

  # --- 3. Segurança do Sistema e Elevação de Privilégios ---
  security.sudo.enable = false;

  security.doas = {
    enable = true;
    extraRules = [{
      users = [ "davi" ];
      keepEnv = false;
      persist = false;
    }];
  };

  security.run0 = {
    wheelNeedsPassword = true;
    enableSudoAlias = true;
  };

  services.howdy = {
    enable = false;
    package = pkgs.howdy;
    settings = {
      video.device = "/dev/video0";
      core.abort_if_no_match = false;
    };
  };

  # --- 4. Ferramentas prontas nos bastidores ---
  environment.systemPackages = [
    pkgs.oath-toolkit
  ];
}

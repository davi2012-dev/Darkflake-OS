{ config, pkgs, ... }: {

  # --- 1. Configuração de Usuários ---
  users.users.davi = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "video" "podman" "libvirtd" "gamemode" "wireshark" "scanner"  ];
    hashedPassword = "$y$j9T$LqaPp07vOk4t3YmqRo8uk/$hFD63tEFFiTFfShOOklyJ1Ne8V8MzTPtyoSVdmvtQ4C";

    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINVu0z9sm4lfgen07lnSkPW/8IiV+N1uGG/Tua9i05le davi@Darkflake" ];
  };

  users.users.guest = {
    isNormalUser = true;
    description = "Usuario Convidado";
    extraGroups = [ ];
    initialPassword = "guest";
  };

  # --- 2. Trancando o Nix (Restrição de Acesso) ---
  nix.settings = {
    allowed-users = [ "root" "@wheel" ];
    trusted-users = [ "root" "davi" ];
  };

  # --- 3. Segurança do Sistema e Elevação de Privilégios ---
  security.sudo.enable = false;

  security.doas = {
    enable = true;
    extraRules = [{
      users = [ "davi" ];
      keepEnv = true;
      persist = true;
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

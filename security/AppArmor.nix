{ config, pkgs, lib, ... }: {

  # 1. Habilita o AppArmor no Kernel e no Sistema
  security.apparmor = {
    enable = true;
    enableCache = true;
    killUnconfinedConfinables = true; # Organizado dentro do bloco do apparmor
    packages = with pkgs; [ 
      apparmor-profiles 
      roddhjav-apparmor-rules 
    ];
  };

  # Configuração de ordem do LSM (Linux Security Modules)
  security.lsm = [ "landlock" "lockdown" "yama" "integrity" "apparmor" "bpf" ];

  # 2. Integra o AppArmor com o barramento de mensagens do sistema
  services.dbus.apparmor = "enabled";
  
  # Evita quebras na autenticação básica do sistema
  security.pam.services.login.enableAppArmor = lib.mkForce false;

  # 3. Automação: Força o AppArmor a carregar antes dos outros serviços
  systemd.services.apparmor.serviceConfig = {
    Type = "oneshot";
    RemainAfterExit = "yes";
  };
}

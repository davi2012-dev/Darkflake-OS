{ config, pkgs, lib, ... }: {

  # 1. Habilita o AppArmor no Kernel e no Sistema
  security.apparmor = {
    enable = true;
    enableCache = true;
    killUnconfinedConfinables = true;
    packages = with pkgs; [ 
      apparmor-profiles
      roddhjav-apparmor-rules
    ];
  };

  # Configuração de ordem do LSM (Linux Security Modules)
  security.lsm = [ "landlock" "lockdown" "yama" "integrity" "apparmor" "bpf" ];

  # 2. Integra o AppArmor com o barramento de mensagens e autenticação
  services.dbus.apparmor = "enabled";
  security.pam.services.login.enableAppArmor = true;

  # 3. Automação: Força o AppArmor a inicializar antes dos outros serviços
  systemd.services.apparmor.serviceConfig = {
    Type = "oneshot";
    RemainAfterExit = "yes";
  };
}

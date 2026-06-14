{ pkgs, ... }: {
  services.usbguard = {
    enable = true;
    # Bloqueia qualquer dispositivo USB novo por padrão
    implicitPolicyTarget = "block";
    
    # Gera a política inicial baseada no que está conectado agora
    # Isso evita que você fique sem teclado ao reiniciar!
    presentDevicePolicy = "apply-policy";
    
    # Permite que o usuário 'davi' gerencie dispositivos via interface/terminal
    IPCAllowedUsers = [ "root" "davi" ];
  };

  # Instala a interface para você autorizar pendrives novos facilmente
  environment.systemPackages = [ pkgs.usbguard-notifier ]; 
}

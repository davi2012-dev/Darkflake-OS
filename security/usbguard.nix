{ pkgs, ... }: {
  services.usbguard = {
    enable = true;
    implicitPolicyTarget = "block";
    presentDevicePolicy = "apply-policy";
    IPCAllowedUsers = [ "root" "davi" ];
  };

  # Instala a interface para você autorizar pendrives novos facilmente
  environment.systemPackages = [ pkgs.usbguard-notifier ]; 
}

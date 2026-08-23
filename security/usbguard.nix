{ pkgs, ... }: {
  services.usbguard = {
    enable = true;
    dbus.enable = true;
    implicitPolicyTarget = "block";
    insertedDevicePolicy = "apply-policy";
    presentDevicePolicy = "apply-policy";
    presentControllerPolicy = "keep";
    IPCAllowedUsers = [ "root" "davi" ];
    IPCAllowedGroups = [ "wheel" ];
  };

  # Instala a interface para você autorizar pendrives novos facilmente
  environment.systemPackages = [ pkgs.usbguard-notifier ]; 
}

{ config, pkgs, ... }: {
  time.timeZone = "America/Bahia";
  i18n.defaultLocale = "pt_BR.UTF-8";

  console = {
    enable = true;
    keyMap = "br-abnt2";
    packages = [ pkgs.terminus_font ];
    font = "ter-v22b";
    earlySetup = true;
    colors = [
      "1e1e2e" "f38ba8" "a6e3a1" "f9e2af"
      "89b4fa" "f5c2e7" "94e2d5" "bac2de"
      "585b70" "f38ba8" "a6e3a1" "f9e2af"
      "89b4fa" "f5c2e7" "94e2d5" "cdd6f4"
    ];
  };

  services.xserver.xkb = {
    layout = "br";
    variant = "abnt2";
  };

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };
}

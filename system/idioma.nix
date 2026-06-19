{ config, pkgs, ... }: {
  # Horário e Localidade
  time.timeZone = "America/Bahia";
  i18n.defaultLocale = "pt_BR.UTF-8";

  # Teclado no Terminal (Console)
  console = {
    enable = true;
    keyMap = "br-abnt2";               # Define o layout do teclado no terminal para ABNT2
    font = "Lat2-Terminus16";          # Uma fonte limpa e legível para modo texto
    earlySetup = true;                 # Carrega o teclado e fonte direto na initrd (evita bug de travar no boot)
  };

  # Teclado no X11 (GDM, Xorg, etc)
  services.xserver.xkb = {
    layout = "br";
    variant = "abnt2";
  };

  # Teclado no Wayland (Gnome moderno usa isso)
  # No Gnome, ele costuma herdar do X11, mas para garantir:
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

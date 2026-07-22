{ config, pkgs, ... }: {
  # --- 1. Horário e Localidade ---
  time.timeZone = "America/Bahia";
  i18n.defaultLocale = "pt_BR.UTF-8";

  # --- 2. Teclado no Terminal (Console TTY) ---
  console = {
    enable = true;
    keyMap = "br-abnt2";              
    font = "sun12x22";        
    earlySetup = true;                
  };

  # --- 3. Teclado no Servidor Gráfico (X11 / Wayland / Display Managers) ---
  services.xserver.xkb = {
    layout = "br";
    variant = "abnt2";
  };

  # --- 4. Variáveis Regionais Extras (Formatos de Data, Moeda e Medidas) ---
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

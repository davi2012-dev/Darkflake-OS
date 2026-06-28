{ config, ... }:

{

  programs.noctalia = {
    enable = true;
    systemd.enable = true; # Ativa o serviço integrado nativo da v5

    settings = {
      bar = {
        density = "compact";
        position = "top";
        barType = "floating";
        showCapsule = true;
        widgets = {
          left = [
            { id = "Launcher"; }
            {
              id = "Clock";
              formatHorizontal = "HH:mm ddd, MMM dd";
              formatVertical = "HH mm";
              useMonospacedFont = true;
              usePrimaryColor = false;
            }
            { id = "SystemMonitor"; }
            {
              id = "VPN";
              displayMode = "alwaysShow";
            }
            { id = "ActiveWindow"; }
            { id = "MediaMini"; }
          ];
          center = [
            {
              id = "Workspace";
              hideUnoccupied = false;
              labelMode = "index";
            }
          ];
          right = [
            { id = "Tray"; }
            { id = "NotificationHistory"; }
            { id = "Volume"; }
            {
              id = "ControlCenter";
              useDistroLogo = true;
              icon = "noctalia";
              enableColorization = true;
            }
          ];
        };
      };

      general = {
        avatarImage = "/home/${config.home.username}/.face";
        launch_apps_as_systemd_services = true; # Recomendado pela doc ao usar systemd
      };

      colorSchemes.predefinedScheme = "Catppuccin-Lavender";

      location = {
        analogClockInCalendar = "true";
        name = "Indianapolis, US";
        useFahrenheit = true;
      };

      network = { };
    };
  };
}

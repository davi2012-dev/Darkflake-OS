{ pkgs, config, inputs, ... }:

let
  # Função adaptada para a v5 do Noctalia chamar os IPCs corretamente no Niri
  noctaliaCmd = cmd: [ "noctalia" "ipc" "call" ] ++ (pkgs.lib.splitString " " cmd);
in
{
  imports = [
    inputs.noctalia.homeModules.default 
    inputs.chaotic.homeManagerModules.default
  ];

  # --- Configuração do Noctalia v5 ---
  programs.noctalia = {
    enable = true;
    
    # Ativa o serviço do Systemd integrado que a doc v5 mencionou!
    systemd.enable = true;

    settings = {
      bar = {
        density = "compact";
        position = "right";
        showCapsule = false;
        widgets = {
          left = [
            { id = "ControlCenter"; useDistroLogo = true; }
            { id = "Network"; }
            { id = "Bluetooth"; }
          ];
          center = [
            { hideUnoccupied = false; id = "Workspace"; labelMode = "none"; }
          ];
          right = [
            { id = "Battery"; warningThreshold = 30; }
            { id = "Clock"; useMonospacedFont = true; usePrimaryColor = true; formatHorizontal = "HH:mm"; }
          ];
        };
      };
      colorSchemes.predefinedScheme = "Monochrome";
      general = {
        avatarImage = "/home/davi/.face"; 
        radiusRatio = 0.2;
        launch_apps_as_systemd_services = true; # Recomendado pela doc ao usar o service
      };
    };
  };

  # --- Configuração do Niri ---
  programs.niri = {
    enable = true;
    settings = {
      
      # Como ativamos o systemd.enable ali em cima, não precisamos mais do spawn-at-startup manual!
      # O próprio systemd vai gerenciar a barra em background.

      # Atalhos de teclado compatíveis com a sintaxe KDL pura do Niri no Home Manager
      binds = {
        "Mod+Space".action.spawn = noctaliaCmd "launcher toggle";
        "Mod+P".action.spawn = noctaliaCmd "sessionMenu toggle";

        "XF86AudioLowerVolume".action.spawn = noctaliaCmd "volume decrease";
        "XF86AudioRaiseVolume".action.spawn = noctaliaCmd "volume increase";
        "XF86AudioMute".action.spawn = noctaliaCmd "volume muteOutput";

        "Mod+Left".action.focus-column-left = { };
        "Mod+Right".action.focus-column-right = { };
        "Mod+Q".action.close-window = { };
      };
    };
  };
}

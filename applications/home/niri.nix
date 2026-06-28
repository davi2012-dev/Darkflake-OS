{ pkgs, config, inputs, ... }:

let
  # Função para os atalhos do Noctalia funcionarem perfeitamente no Niri
  noctalia = cmd: [ "noctalia-shell" "ipc" "call" ] ++ (pkgs.lib.splitString " " cmd);
in
{
  imports = [
    inputs.noctalia.homeModules.default 
    inputs.chaotic.homeManagerModules.default
  ];

  # --- Configuração do Noctalia Shell ---
  programs.noctalia-shell = {
    enable = true;
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
      };
    };
  };

  # --- Configuração do Niri ---
  programs.niri = {
    enable = true; # Ativa o Niri para o seu usuário davi
    settings = {
      
      # Inicia o Noctalia automaticamente junto com o Niri
      spawn-at-startup = [
        { command = [ "noctalia-shell" ]; }
      ];

      # Configura os atalhos de teclado dentro do Niri
      binds = with config.lib.niri.actions; {
        # Abrir o Menu com Super + Espaço
        "Mod+Space".action.spawn = noctalia "launcher toggle";

        # Menu de energia com Super + P
        "Mod+P".action.spawn = noctalia "sessionMenu toggle";

        # Teclas de Volume
        "XF86AudioLowerVolume".action.spawn = noctalia "volume decrease";
        "XF86AudioRaiseVolume".action.spawn = noctalia "volume increase";
        "XF86AudioMute".action.spawn = noctalia "volume muteOutput";

        # Movimentação básica de janelas do Niri (Exemplo)
        "Mod+Left".action.focus-column-left = null;
        "Mod+Right".action.focus-column-right = null;
        "Mod+Q".action.close-window = null;
      };
    };
  };
}

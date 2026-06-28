{ pkgs, config, inputs, ... }:

let
  # Função para os atalhos do Noctalia funcionarem perfeitamente no Niri
  # Ela já gera a estrutura exata de lista que o spawn do Niri precisa
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
    enable = true;
    settings = {
      
      # Inicia o Noctalia automaticamente junto com o Niri
      spawn-at-startup = [
        { command = [ "noctalia-shell" ]; }
      ];

      # Configura os atalhos de teclado dentro do Niri usando a sintaxe correta
      binds = with config.lib.niri.actions; {
        # Corrigido: spawn precisa dos parênteses para processar a função 'noctalia' primeiro
        "Mod+Space".action = spawn (noctalia "launcher toggle");
        "Mod+P".action = spawn (noctalia "sessionMenu toggle");

        # Teclas de Volume (perfeito)
        "XF86AudioLowerVolume".action = spawn (noctalia "volume decrease");
        "XF86AudioRaiseVolume".action = spawn (noctalia "volume increase");
        "XF86AudioMute".action = spawn (noctalia "volume muteOutput");

        # Movimentação de janelas (perfeito)
        "Mod+Left".action = focus-column-left;
        "Mod+Right".action = focus-column-right;
        "Mod+Q".action = close-window;
      };
    };
  };
}

{ pkgs, config, inputs, ... }:

let
  noctalia = cmd: [ "noctalia-shell" "ipc" "call" ] ++ (pkgs.lib.splitString " " cmd);
in
{
  # Força o Home Manager a engolir o módulo direto dos inputs
  imports = [
    inputs.noctalia.homeModules.default 
    inputs.chaotic.homeManagerModules.default
  ];

  programs.noctalia-shell = {
    enable = true;
    # ... suas configurações do noctalia ...
  };

  programs.niri = {
    enable = true;
    settings = {
      spawn-at-startup = [
        { command = [ "noctalia-shell" ]; }
      ];
      binds = {
        "Mod+Space".action.spawn = noctalia "launcher toggle";
        "Mod+P".action.spawn = noctalia "sessionMenu toggle";
        "XF86AudioLowerVolume".action.spawn = noctalia "volume decrease";
        "XF86AudioRaiseVolume".action.spawn = noctalia "volume increase";
        "XF86AudioMute".action.spawn = noctalia "volume muteOutput";

        "Mod+Left".action.focus-column-left = { };
        "Mod+Right".action.focus-column-right = { };
        "Mod+Q".action.close-window = { };
      };
    };
  };
}

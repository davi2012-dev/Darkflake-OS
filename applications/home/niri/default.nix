{
  inputs,
  ...
}:

{
  imports = [
    ./settings.nix # Your custom configuration files for Niri
    ./keybinds.nix
    ./rules.nix
    ./autostart.nix
    ./scripts.nix
    ./noctaliashell.nix
  ];
}

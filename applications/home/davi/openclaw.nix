{ pkgs, ... }:

{
  # ========== OPENCLAW - Assistente de IA Auto-hospedado ==========
  home.packages = with pkgs; [
    openclaw
  ];
}

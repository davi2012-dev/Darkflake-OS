{ config, pkgs, ... }:

{
  # ========== CAVA - Visualizador de Áudio ==========
  programs.cava = {
    enable = true;
    settings = {
      # Configuração geral
      general = {
        framerate = 60;
        autosens = 1;
        sensitivity = 100;
        bars = 0;          # 0 = automatic
        bar_height = 20;
        bar_width = 2;
        bar_spacing = 1;
        lower_cutoff_freq = 50;
        higher_cutoff_freq = 10000;
        sleep_timer = 0;
        stereo = 1;
        reverse = 0;
        method = "pulse";
        source = "auto";
        stereo = 1;
      };

      # ===== GRADIENTE DE CORES =====
      color = {
        gradient = 1;
        gradient_count = 8;
        gradient_color_1 = "'#94e2d5'";
        gradient_color_2 = "'#89dceb'";
        gradient_color_3 = "'#74c7ec'";
        gradient_color_4 = "'#89b4fa'";
        gradient_color_5 = "'#cba6f7'";
        gradient_color_6 = "'#f5c2e7'";
        gradient_color_7 = "'#eba0ac'";
        gradient_color_8 = "'#f38ba8'";
      };

      # Configuração de saída (opcional)
      output = {
        method = "ncurses";
        channels = "stereo";
        bit_format = "16bit";
      };
    };
  };
}

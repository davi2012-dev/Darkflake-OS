{ config, pkgs, ... }:

{
  services.pipewire.extraConfig.pipewire."99-radio-effect" = {
    "context.modules" = [
      {
        name = "libpipewire-module-filter-chain";
        args = {
          "node.description" = "Efeito Rádio FM";
          "media.name" = "Radio FM";
          "filter.graph" = {
            "nodes" = [
              # 1. Equalizador (Filtro Passa-Faixa)
              {
                type = "builtin";
                label = "equalizer";
                name = "eq";
                config = {
                  "bands" = [
                    { freq = 300;  gain = -12.0; q = 0.7; } # Corta graves profundos
                    { freq = 3000; gain = -12.0; q = 0.7; } # Corta agudos
                    { freq = 1000; gain = 2.0; q = 1.0; }   # Realça os médios (voz)
                  ];
                };
              }
              # 2. Compressor (para dar o "gás" do rádio)
              {
                type = "builtin";
                label = "compressor";
                name = "comp";
                config = {
                  "threshold" = -15.0;   # dB
                  "ratio" = 4.0;
                  "attack" = 5.0;        # ms
                  "release" = 100.0;     # ms
                  "makeup_gain" = 5.0;   # dB
                };
              }
            ];
            "inputs" = [ "eq:In L" "eq:In R" ];
            "outputs" = [ "comp:Out L" "comp:Out R" ];
            # Conecta a saída do EQ na entrada do Compressor
            "links" = [
              { output = "eq:Out L"; input = "comp:In L"; }
              { output = "eq:Out R"; input = "comp:In R"; }
            ];
          };
          "capture.props" = {
            "node.name" = "effect_input.radio";
            "media.class" = "Audio/Sink";
            "audio.channels" = 2;
            "audio.position" = [ "FL" "FR" ];
          };
          "playback.props" = {
            "node.name" = "effect_output.radio";
            "node.passive" = true;
            "audio.channels" = 2;
            "audio.position" = [ "FL" "FR" ];
          };
        };
      }
    ];
  };
}

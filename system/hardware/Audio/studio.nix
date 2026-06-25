{ config, pkgs, ... }:

let
  # Caminho para o plugin saturator
  saturator = "${pkgs.ladspaPlugins}/lib/ladspa/tap_saturator.so";
in
{
  services.pipewire.extraConfig.pipewire."99-studio" = {
    "context.modules" = [
      {
        name = "libpipewire-module-filter-chain";
        args = {
          "node.description" = "Vintage Studio (EQ + Comp + Sat)";
          "media.name" = "Studio Vintage";
          "filter.graph" = {
            "nodes" = [
              # 1. Equalizador estilo "Pultec" (shelves + pico)
              {
                type = "builtin";
                label = "param_eq";
                name = "eq";
                config = {
                  "filters" = [
                    { type = "bq_lowshelf"; freq = 60;  gain = 4.0;  q = 0.7; }   # realce grave
                    { type = "bq_highshelf"; freq = 8000; gain = 3.0;  q = 0.7; }  # realce agudo
                    { type = "bq_peaking"; freq = 300;  gain = -2.0; q = 1.0; }   # corta médio-baixo
                    { type = "bq_peaking"; freq = 3000; gain = 1.5;  q = 2.0; }   # realce presença
                  ];
                };
              }
              # 2. Compressor estilo "LA-2A" (lento, suave)
              {
                type = "builtin";
                label = "compressor";
                name = "comp";
                config = {
                  "threshold" = -18.0;   # dB
                  "ratio" = 3.0;
                  "attack" = 10.0;       # ms (lento)
                  "release" = 150.0;     # ms (lento)
                  "makeup_gain" = 6.0;   # dB
                };
              }
              # 3. Saturator (simula válvulas/fita)
              {
                type = "ladspa";
                label = "tap_saturator";
                name = "sat";
                plugin = saturator;
                control = {
                  "Drive" = 0.5;          # 0 a 1, quanto mais drive, mais distorção
                  "Clip" = 0.0;           # 0 = soft clip, 1 = hard clip (deixe em 0)
                };
              }
            ];
            # Conexões em série: EQ → Compressor → Saturator
            "links" = [
              { output = "eq:Out L"; input = "comp:In L"; }
              { output = "eq:Out R"; input = "comp:In R"; }
              { output = "comp:Out L"; input = "sat:In L"; }
              { output = "comp:Out R"; input = "sat:In R"; }
            ];
            "inputs" = [ "eq:In L" "eq:In R" ];
            "outputs" = [ "sat:Out L" "sat:Out R" ];
          };
          "capture.props" = {
            "node.name" = "effect_input.studio";
            "media.class" = "Audio/Sink";
            "audio.channels" = 2;
            "audio.position" = [ "FL" "FR" ];
          };
          "playback.props" = {
            "node.name" = "effect_output.studio";
            "node.passive" = true;
            "audio.channels" = 2;
            "audio.position" = [ "FL" "FR" ];
          };
        };
      }
    ];
  };
}

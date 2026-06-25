{ config, pkgs, ... }:

let
  saturator = "${pkgs.ladspaPlugins}/lib/ladspa/tap_saturator.so";
in
{
  services.pipewire.extraConfig.pipewire."99-retro-pc" = {
    "context.modules" = [
      {
        name = "libpipewire-module-filter-chain";
        args = {
          "node.description" = "Retro PC (anos 90/2000)";
          "media.name" = "PC Antigo";
          "filter.graph" = {
            "nodes" = [
              # 1. Equalizador para som "fino" e metálico
              {
                type = "builtin";
                label = "param_eq";
                name = "eq";
                config = {
                  "filters" = [
                    { type = "bq_highpass"; freq = 150;  gain = 0;   q = 0.7; }  # corta graves abaixo de 150Hz
                    { type = "bq_peaking";  freq = 300;  gain = -4.0; q = 0.7; }  # corta médio-graves (tira corpo)
                    { type = "bq_peaking";  freq = 2000; gain = 6.0;  q = 1.5; }  # realça agudos (metálico)
                    { type = "bq_highshelf"; freq = 8000; gain = -5.0; q = 0.7; }  # corta agudos extremos (simula limitador)
                    { type = "bq_peaking";  freq = 400;  gain = -2.0; q = 1.0; }   # reduz ainda mais a região do vocal
                  ];
                };
              }
              # 2. Compressor agressivo (achata a dinâmica)
              {
                type = "builtin";
                label = "compressor";
                name = "comp";
                config = {
                  "threshold" = -15.0;
                  "ratio" = 6.0;
                  "attack" = 2.0;      # ms
                  "release" = 50.0;    # ms
                  "makeup_gain" = 4.0;
                };
              }
              # 3. Saturator para simular DAC barato
              {
                type = "ladspa";
                label = "tap_saturator";
                name = "sat";
                plugin = saturator;
                control = {
                  "Drive" = 0.3;       # 0 a 1, um pouco de saturação
                  "Clip" = 0.0;        # soft clip
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
            "node.name" = "effect_input.retropc";
            "media.class" = "Audio/Sink";
            "audio.channels" = 2;
            "audio.position" = [ "FL" "FR" ];
          };
          "playback.props" = {
            "node.name" = "effect_output.retropc";
            "node.passive" = true;
            "audio.channels" = 2;
            "audio.position" = [ "FL" "FR" ];
          };
        };
      }
    ];
  };
}

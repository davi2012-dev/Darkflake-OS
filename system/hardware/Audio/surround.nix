{ config, pkgs, ... }:

let
  hrtf_file = pkgs.fetchurl {
    url = "https://github.com/ValveSoftware/steam-audio/raw/master/core/data/hrtf/sadie_d1.sofa";
    sha256 = "sha256-5scqhN2Ue173VDirlqnCoy7RDwM0crnEwRpJr/AKijE=";
  };
in
{
  environment.systemPackages = [ pkgs.rnnoise-plugin ];

  services.pipewire.extraConfig.pipewire = {
    "98-virtual-channels" = {
      "context.modules" = [
        {
          name = "libpipewire-module-loopback";
          args = {
            "node.description" = "Game";
            "capture.props" = { "node.name" = "game_output"; "media.class" = "Audio/Sink"; "audio.position" = [ "FL" "FR" ]; };
            "playback.props" = { "node.name" = "playback.game_output"; "audio.position" = [ "FL" "FR" ]; "node.passive" = true; };
          };
        }
        {
          name = "libpipewire-module-loopback";
          args = {
            "node.description" = "Voice";
            "capture.props" = { "node.name" = "voice_output"; "media.class" = "Audio/Sink"; "audio.position" = [ "FL" "FR" ]; };
            "playback.props" = { "node.name" = "playback.voice_output"; "audio.position" = [ "FL" "FR" ]; "node.passive" = true; };
          };
        }
        {
          name = "libpipewire-module-loopback";
          args = {
            "node.description" = "Browser";
            "capture.props" = { "node.name" = "browser_output"; "media.class" = "Audio/Sink"; "audio.position" = [ "FL" "FR" ]; };
            "playback.props" = { "node.name" = "playback.browser_output"; "audio.position" = [ "FL" "FR" ]; "node.passive" = true; };
          };
        }
        {
          name = "libpipewire-module-loopback";
          args = {
            "node.description" = "Music";
            "capture.props" = { "node.name" = "music_output"; "media.class" = "Audio/Sink"; "audio.position" = [ "FL" "FR" ]; };
            "playback.props" = { "node.name" = "playback.music_output"; "audio.position" = [ "FL" "FR" ]; "node.passive" = true; };
          };
        }
      ];
    };

    "99-spatializer" = {
      "context.modules" = [
        {
          name = "libpipewire-module-filter-chain";
          args = {
            "node.description" = "Virtual Headphone Surround";
            "media.name" = "Virtual Headphone Surround";
            "filter.graph" = {
              "nodes" = [
                { type = "sofa"; label = "spatializer"; name = "spFL"; config = { filename = "${hrtf_file}"; }; control = { "Azimuth" = 30.0; "Elevation" = 0.0; "Radius" = 3.0; }; }
                { type = "sofa"; label = "spatializer"; name = "spFR"; config = { filename = "${hrtf_file}"; }; control = { "Azimuth" = 330.0; "Elevation" = 0.0; "Radius" = 3.0; }; }
                { type = "sofa"; label = "spatializer"; name = "spFC"; config = { filename = "${hrtf_file}"; }; control = { "Azimuth" = 0.0; }; }
                { type = "sofa"; label = "spatializer"; name = "spLFE"; config = { filename = "${hrtf_file}"; }; control = { "Azimuth" = 0.0; "Elevation" = -60.0; }; }
                { type = "sofa"; label = "spatializer"; name = "spRL"; config = { filename = "${hrtf_file}"; }; control = { "Azimuth" = 150.0; }; }
                { type = "sofa"; label = "spatializer"; name = "spRR"; config = { filename = "${hrtf_file}"; }; control = { "Azimuth" = 210.0; }; }
                { type = "sofa"; label = "spatializer"; name = "spSL"; config = { filename = "${hrtf_file}"; }; control = { "Azimuth" = 90.0; }; }
                { type = "sofa"; label = "spatializer"; name = "spSR"; config = { filename = "${hrtf_file}"; }; control = { "Azimuth" = 270.0; }; }
                { type = "builtin"; label = "mixer"; name = "mixL"; }
                { type = "builtin"; label = "mixer"; name = "mixR"; }
              ];
              "links" = [
                { output = "spFL:Out L";  input="mixL:In 1"; } { output = "spFL:Out R";  input="mixR:In 1"; }
                { output = "spFR:Out L";  input="mixL:In 2"; } { output = "spFR:Out R";  input="mixR:In 2"; }
                { output = "spFC:Out L";  input="mixL:In 3"; } { output = "spFC:Out R";  input="mixR:In 3"; }
                { output = "spRL:Out L";  input="mixL:In 4"; } { output = "spRL:Out R";  input="mixR:In 4"; }
                { output = "spRR:Out L";  input="mixL:In 5"; } { output = "spRR:Out R";  input="mixR:In 5"; }
                { output = "spSL:Out L";  input="mixL:In 6"; } { output = "spSL:Out R";  input="mixR:In 6"; }
                { output = "spSR:Out L";  input="mixL:In 7"; } { output = "spSR:Out R";  input="mixR:In 7"; }
                { output = "spLFE:Out L"; input="mixL:In 8"; } { output = "spLFE:Out R"; input="mixR:In 8"; }
              ];
              "inputs" = [ "spFL:In" "spFR:In" "spFC:In" "spLFE:In" "spRL:In" "spRR:In" "spSL:In" "spSR:In" ];
              "outputs" = [ "mixL:Out" "mixR:Out" ];
            };
            "capture.props" = {
              "node.name" = "effect_input.spatializer";
              "media.class" = "Audio/Sink";
              "audio.channels" = 8;
              "audio.position" = [ "FL" "FR" "FC" "LFE" "RL" "RR" "SL" "SR" ];
            };
            "playback.props" = {
              "node.name" = "effect_output.spatializer";
              "node.passive" = true;
              "audio.channels" = 2;
              "audio.position" = [ "FL" "FR" ];
            };
          };
        }
      ];
    };

    "100-voice-isolation" = {
      "context.modules" = [
        {
          name = "libpipewire-module-filter-chain";
          args = {
            "node.description" = "Voice Isolation (RNNoise)";
            "media.name" = "Voice Isolation (RNNoise)";
            "filter.graph" = {
              "nodes" = [
                {
                  type = "ladspa";
                  name = "rnnoise";
                  plugin = "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
                  label = "noise_suppressor_mono";
                  control = {
                    "VAD Threshold (%)" = 50.0;
                    "VAD Grace Period (ms)" = 200;
                    "Retroactive VAD Grace (ms)" = 0;
                  };
                }
              ];
            };
            "capture.props" = {
              "node.name" = "capture.rnnoise_source";
              "node.passive" = true;
              "audio.rate" = 48000;
            };
            "playback.props" = {
              "node.name" = "rnnoise_source";
              "media.class" = "Audio/Source";
              "audio.rate" = 48000;
            };
          };
        }
      ];
    };

    "101-apple-eq-presets" = {
      "context.modules" = [
        {
          name = "libpipewire-module-filter-chain";
          args = {
            "node.description" = "Bass Booster (estilo Apple Music)";
            "media.name" = "Bass Booster (estilo Apple Music)";
            "filter.graph" = {
              "nodes" = [
                { type = "builtin"; label = "bq_lowshelf"; name = "bassBoost"; control = { "Freq" = 150.0; "Q" = 0.7; "Gain" = 6.0; }; }
              ];
            };
            "capture.props" = { "node.name" = "bass_booster_output"; "media.class" = "Audio/Sink"; "audio.position" = [ "FL" "FR" ]; };
            "playback.props" = { "node.name" = "playback.bass_booster_output"; "audio.position" = [ "FL" "FR" ]; "node.passive" = true; };
          };
        }
        {
          name = "libpipewire-module-filter-chain";
          args = {
            "node.description" = "Treble Booster (estilo Apple Music)";
            "media.name" = "Treble Booster (estilo Apple Music)";
            "filter.graph" = {
              "nodes" = [
                { type = "builtin"; label = "bq_highshelf"; name = "trebleBoost"; control = { "Freq" = 6000.0; "Q" = 0.7; "Gain" = 5.0; }; }
              ];
            };
            "capture.props" = { "node.name" = "treble_booster_output"; "media.class" = "Audio/Sink"; "audio.position" = [ "FL" "FR" ]; };
            "playback.props" = { "node.name" = "playback.treble_booster_output"; "audio.position" = [ "FL" "FR" ]; "node.passive" = true; };
          };
        }
      ];
    };
  };
}

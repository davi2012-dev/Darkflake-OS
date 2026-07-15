{ config, pkgs, lib, ... }:

let
  romsDirs = [
    "3do" "3ds" "amiga" "arcade" "atari" "atari-2600" "atari-5200" "atari-7800"
    "atomiswave" "bandai-wonderswan" "cdi" "channel-f" "colecovision" "dreamcast"
    "ds" "famicom" "fba" "fds" "GameCube" "game-gear" "gb" "gba" "gbc" "genesis"
    "intellivision" "jaguar" "mame" "master-system" "MegaDrive" "msx" "n64"
    "neo-geo" "neo-geo-aes" "neo-geo-cd" "neo-geo-pocket" "nes" "ngp" "ngpc"
    "openbor" "pc98" "pce" "pce-cd" "pcfx" "pokemini" "ps1" "ps2" "psp" "saturn"
    "segacd" "sega-32x" "sega-cd" "sfc" "sg-1000" "snes" "sufami-turbo"
    "supergrafx" "switch" "turbo-grafx-16" "turbo-grafx-cd" "vectrex"
    "virtualboy" "windows" "wii" "wonderswan" "wonderswan-color" "xbox" "zelda64"
  ];

  biosDirs = [
    "3do" "3ds" "amiga" "arcade" "atari" "atari-2600" "atari-5200" "atari-7800"
    "atomiswave" "bandai-wonderswan" "cdi" "channel-f" "colecovision" "dreamcast"
    "famicom" "fba" "fds" "gamecube" "game-gear" "gb" "gba" "gbc" "genesis"
    "intellivision" "jaguar" "mame" "master-system" "megadrive" "msx" "n64"
    "neo-geo" "neo-geo-aes" "neo-geo-cd" "neo-geo-pocket" "nes" "ngp" "ngpc"
    "openbor" "pc98" "pce" "pce-cd" "pcfx" "pokemini" "ps1" "ps2" "psp" "saturn"
    "segacd" "sega-32x" "sega-cd" "sfc" "sg-1000" "snes" "sufami-turbo"
    "supergrafx" "switch" "turbo-grafx-16" "turbo-grafx-cd" "vectrex"
    "virtualboy" "wii" "wonderswan" "wonderswan-color" "xbox" "zelda64"
  ];

in {
  systemd.user.services = {
    create-roms-dirs = {
      Unit = {
        Description = "Create ROM directories";
        After = [ "local-fs.target" ];
      };
      Service = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = pkgs.writeShellScript "create-roms-dirs" ''
          for dir in ${lib.concatStringsSep " " romsDirs}; do
            mkdir -p /home/games/roms/$dir
          done
          chown -R davi:users /home/games/roms
        '';
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };

    create-bios-dirs = {
      Unit = {
        Description = "Create BIOS directories";
        After = [ "local-fs.target" "create-roms-dirs.service" ];
      };
      Service = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = pkgs.writeShellScript "create-bios-dirs" ''
          for dir in ${lib.concatStringsSep " " biosDirs}; do
            mkdir -p /home/games/bios/$dir
          done
          chown -R davi:users /home/games/bios
        '';
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };

  programs.retroarch = {
    enable = true;
    cores = {
      mgba.enable = true;
      snes9x = {
        enable = true;
        package = pkgs.libretro.snes9x2010;
      };
      genesis-plus-gx.enable = true;
      gambatte.enable = true;
      mupen64plus.enable = true;
      np2kai.enable = true;
      beetle-saturn.enable = true;
      fmsx.enable = true;
      virtualjaguar.enable = true;
      mame.enable = true;
      desmume.enable = true;
      flycast.enable = true;
    };
    settings = {
      video_driver = "vulkan";
      video_fullscreen = "true";
      system_directory = "/home/games/bios";
      rgui_browser_directory = "/home/games/roms";
      playlist_directory = "/home/games/roms";
    };
  };
}

{ config, pkgs, lib, ... }:

let
  romSystems = [
    "3do" "3ds" "amiga" "arcade" "atari" "atari-2600" "atari-5200" "atari-7800"
    "atomiswave" "bandai-wonderswan" "cdi" "channel-f" "colecovision" "dreamcast"
    "ds" "famicom" "fba" "fds" "gamecube" "game-gear" "gb" "gba" "gbc" "genesis"
    "intellivision" "jaguar" "mame" "master-system" "megadrive" "msx" "n64"
    "neo-geo" "neo-geo-aes" "neo-geo-cd" "neo-geo-pocket" "nes" "ngp" "ngpc"
    "openbor" "pc98" "pce" "pce-cd" "pcfx" "pokemini" "ps1" "ps2" "psp" "saturn"
    "segacd" "sega-32x" "sega-cd" "sfc" "sg-1000" "snes" "sufami-turbo"
    "supergrafx" "switch" "turbo-grafx-16" "turbo-grafx-cd" "vectrex" "ps3" "xbox360"
    "virtualboy" "windows" "wii" "wonderswan" "wonderswan-color" "xbox" "zelda64"
  ];

  biosSystems = [
    "3do" "3ds" "amiga" "arcade" "atari" "atari-2600" "atari-5200" "atari-7800"
    "atomiswave" "bandai-wonderswan" "cdi" "channel-f" "colecovision" "dreamcast"
    "famicom" "fba" "fds" "gamecube" "game-gear" "gb" "gba" "gbc" "genesis"
    "intellivision" "jaguar" "mame" "master-system" "megadrive" "msx" "n64" "ps3" "xbox360"
    "neo-geo" "neo-geo-aes" "neo-geo-cd" "neo-geo-pocket" "nes" "ngp" "ngpc"
    "openbor" "pc98" "pce" "pce-cd" "pcfx" "pokemini" "ps1" "ps2" "psp" "saturn"
    "segacd" "sega-32x" "sega-cd" "sfc" "sg-1000" "snes" "sufami-turbo"
    "supergrafx" "switch" "turbo-grafx-16" "turbo-grafx-cd" "vectrex"
    "virtualboy" "windows" "wii" "wonderswan" "wonderswan-color" "xbox" "zelda64"
  ];

  createRomsDirs = pkgs.writeShellScript "create-roms-dirs" ''
    for dir in ${lib.concatStringsSep " " romSystems}; do
      mkdir -p /home/games/roms/$dir
    done
    chown -R davi:users /home/games/roms
  '';

  createBiosDirs = pkgs.writeShellScript "create-bios-dirs" ''
    for dir in ${lib.concatStringsSep " " biosSystems}; do
      mkdir -p /home/games/bios/$dir
    done
    chown -R davi:users /home/games/bios
  '';

  createOtherDirs = pkgs.writeShellScript "create-other-dirs" ''
    mkdir -p /home/games/saves
    mkdir -p /home/games/states
    mkdir -p /home/games/screenshots
    mkdir -p /home/games/recordings
    mkdir -p /home/games/playlists
    mkdir -p /home/games/thumbnails
    mkdir -p /home/games/cheats
    mkdir -p /home/games/overlays
    mkdir -p /home/games/shaders
    mkdir -p /home/games/config
    chown -R davi:users /home/games
  '';

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
        ExecStart = createRomsDirs;
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
        ExecStart = createBiosDirs;
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };

    create-other-dirs = {
      Unit = {
        Description = "Create other emulator directories";
        After = [ "local-fs.target" "create-roms-dirs.service" "create-bios-dirs.service" ];
      };
      Service = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = createOtherDirs;
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };

  programs.retroarch = {
    enable = true;
    cores = {
      # NINTENDO
      mgba.enable = true;           # Game Boy Advance
      gambatte.enable = true;       # Game Boy/Color
      snes9x = {                    # Super Nintendo
        enable = true;
        package = pkgs.libretro.snes9x2010;
      };
      mesen.enable = true;          # NES/Famicom
      mupen64plus.enable = true;    # Nintendo 64
      desmume.enable = true;        # Nintendo DS
      dolphin.enable = true;        # GameCube/Wii

      # SEGA
      genesis-plus-gx.enable = true;  # Sega Genesis/MegaDrive
      picodrive.enable = true;        # Sega 32X, CD, MegaDrive
      beetle-saturn.enable = true;    # Sega Saturn
      flycast.enable = true;          # Sega Dreamcast

      # SONY
      beetle-psx.enable = true;       # PlayStation 1

      # ARCADE
      mame.enable = true;             # MAME Arcade
      fbalpha2012.enable = true;      # Final Burn Alpha (NÃO é fbalpha!)

      # OUTROS
      np2kai.enable = true;           # PC-98
      fmsx.enable = true;             # MSX
      handy.enable = true;            # Atari Lynx
      puae.enable = true;             # Amiga
      scummvm.enable = true;          # ScummVM
      stella.enable = true;           # Atari 2600
      virtualjaguar.enable = true;    # Atari Jaguar
    };

    settings = {
      video_driver = "vulkan";
      video_fullscreen = "true";
      system_directory = "/home/games/bios";
      rgui_browser_directory = "/home/games/roms";
      playlist_directory = "/home/games/playlists";
      savefile_directory = "/home/games/saves";
      savestate_directory = "/home/games/states";
      screenshot_directory = "/home/games/screenshots";
      recording_output_directory = "/home/games/recordings";
      thumbnail_directory = "/home/games/thumbnails";
      cheat_database_path = "/home/games/cheats";
      overlay_directory = "/home/games/overlays";
      shader_directory = "/home/games/shaders";
      config_save_on_exit = "true";
      menu_driver = "xmb";
    };
  };
}

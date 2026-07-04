{ config, pkgs, ... }: {
  programs.retroarch = {
    enable = true;
    
    cores = {
      # Game Boy Advance
      mgba.enable = true;  

      # Super Nintendo (versão 2010)
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
    };
  };
}

{ pkgs, ... }:

{
  programs.mpv = {
    enable = true;

    scripts = with pkgs.mpvScripts; [ 
      mpris                    
      thumbfast                
      quality-menu            
    ];

    config = {
      # --- Rendering ---
      profile = "gpu-hq";
      hwdec = "auto";
      vo = "gpu";              

      # --- Display ---
      osd-bar = true;
      osd-duration = 2000;     
      osd-font-size = 32;     
      
      cursor-autohide = 1000;  # Hide cursor after 1s
      keep-open = true;
      force-window = true;

      # --- Subtitles ---
      sub-auto = "fuzzy";      # ✅ Auto-load subs (fuzzy matching)
      sub-font-size = 45;
      sub-color = "#FFFFFF";

      # --- Audio ---
      volume = 100;
      volume-max = 150;        
      audio-file-auto = "fuzzy"; # ✅ Auto-load áudio

      # --- Playback ---
      loop-playlist = "inf";   # ✅ Loop infinito na playlist
      resume-playback = true;  

      # --- Network ---
      ytdl-format = "bestvideo+bestaudio"; 

      # --- Performance ---
      cache = "yes";
      demuxer-max-bytes = "500MiB";
    };

    bindings = {
      # --- Seek (vim-style) ---
      "h" = "seek -5";
      "l" = "seek 5";
      "H" = "seek -60";
      "L" = "seek 60";
      "0" = "seek 0 absolute";  # goto start
      "End" = "seek 100 absolute-percent"; #  goto end

      # --- Volume (vim-style) ---
      "j" = "add volume -5";
      "k" = "add volume 5";
      "J" = "add volume -15";
      "K" = "add volume 15";
      "m" = "cycle mute";       #  mute toggle

      # --- Playback ---
      "space" = "cycle pause";
      ">" = "playlist-next";    # next file
      "<" = "playlist-prev";    # prev file
      "q" = "quit";

      # --- Subtitles & Audio ---
      "s" = "cycle sub";
      "S" = "cycle sub-visibility"; #  toggle sub visibility
      "a" = "cycle audio";      # cycle audio tracks
      "c" = "cycle sub-pos";    #  subtitle position

      # --- UI ---
      "p" = "script-binding osc/visibility";
      "i" = "script-binding stats/toggle-stats"; #  show stats
      "I" = "script-binding stats/toggle-stats-full"; #  full stats

      # --- Speed ---
      "[" = "multiply speed 0.9"; # slow down
      "]" = "multiply speed 1.1"; #  speed up
      "=" = "set speed 1";        # reset speed

      # --- Rotation ---
      "r" = "cycle-values video-rotate 0 90 180 270"; # rotate video

      # --- Screenshot ---
      "Print" = "screenshot";   #  print screen
      "Shift+Print" = "screenshot subtitles"; #  with subs

      # --- Fullscreen ---
      "f" = "cycle fullscreen";
      "ESC" = "set fullscreen no"; #  sair fullscreen

      # --- Bookmarks/Marks ---
      "B" = "cycle-values video-aspect-ratio 16:9 4:3 2.39:1 16:10"; # Aspect ratio
    };
  };
}

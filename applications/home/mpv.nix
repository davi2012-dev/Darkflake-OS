{ pkgs, ... }:

{
  # ==========================================
  # 1. MPV Autônomo (Para abrir arquivos locais)
  # ==========================================
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
      "0" = "seek 0 absolute";  
      "End" = "seek 100 absolute-percent"; 

      # --- Volume (vim-style) ---
      "j" = "add volume -5";
      "k" = "add volume 5";
      "J" = "add volume -15";
      "K" = "add volume 15";
      "m" = "cycle mute";       

      # --- Playback ---
      "space" = "cycle pause";
      ">" = "playlist-next";    
      "<" = "playlist-prev";    
      "q" = "quit";

      # --- Subtitles & Audio ---
      "s" = "cycle sub";
      "S" = "cycle sub-visibility"; 
      "a" = "cycle audio";      
      "c" = "cycle sub-pos";    

      # --- UI ---
      "p" = "script-binding osc/visibility";
      "i" = "script-binding stats/toggle-stats"; 
      "I" = "script-binding stats/toggle-stats-full"; 

      # --- Speed ---
      "[" = "multiply speed 0.9"; 
      "]" = "multiply speed 1.1"; 
      "=" = "set speed 1";        

      # --- Rotation ---
      "r" = "cycle-values video-rotate 0 90 180 270"; 

      # --- Screenshot ---
      "Print" = "screenshot";   
      "Shift+Print" = "screenshot subtitles"; 

      # --- Fullscreen ---
      "f" = "cycle fullscreen";
      "ESC" = "set fullscreen no"; 

      # --- Bookmarks/Marks ---
      "B" = "cycle-values video-aspect-ratio 16:9 4:3 2.39:1 16:10"; 
    };
  };

  # ==========================================
  # 2. Transmissão do Jellyfin (Jellyfin MPV Shim)
  # ==========================================
  services.jellyfin-mpv-shim = {
    enable = true;

    # Configurações do próprio cliente Shim
    settings = {
      fullscreen = true;
      always_on_top = false;
      use_web_client = false; 
    };

    # Herda as configurações de renderização/comportamento do seu MPV
    mpvConfig = {
      profile = "gpu-hq";
      hwdec = "auto-safe"; # auto-safe é mais estável para o ecossistema do Shim
      vo = "gpu";
      sub-auto = "fuzzy";
      sub-font-size = "45"; # O módulo do Shim exige strings para números aqui
      sub-color = "#FFFFFF";
      volume = "100";
      volume-max = "150";
      cache = "yes";
      demuxer-max-bytes = "500MiB";
    };

    # Herda os seus atalhos Vim-style para usar durante a transmissão
    mpvInput = {
      "h" = "seek -5";
      "l" = "seek 5";
      "H" = "seek -60";
      "L" = "seek 60";
      "j" = "add volume -5";
      "k" = "add volume 5";
      "J" = "add volume -15";
      "K" = "add volume 15";
      "m" = "cycle mute";
      "SPACE" = "cycle pause";
      ">" = "playlist-next";
      "<" = "playlist-prev";
      "s" = "cycle sub";
      "S" = "cycle sub-visibility";
      "a" = "cycle audio";
      "f" = "cycle fullscreen";
      "ESC" = "set fullscreen no";
    };
  };
}

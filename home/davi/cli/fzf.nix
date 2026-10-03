{ ... }:

{
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    defaultCommand = "fd --hidden --strip-cwd-prefix --exclude '.git'";
    fileWidgetCommand = "fd --type f --hidden --strip-cwd-prefix --exclude '.git'";
    changeDirWidgetCommand = "fd --type d --hidden --strip-cwd-prefix --exclude '.git'";
    defaultOptions = [
      "--layout=reverse"
      "--cycle"
      "--height=50%"
      "--margin=5%"
      "--border=double"
    ];
  };
}

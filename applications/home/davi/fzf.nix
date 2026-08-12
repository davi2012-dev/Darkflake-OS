{ ... }:
{
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    defaultCommand = "fd --hidden --strip-cwd-prefix --exclude '.git'";
    defaultOptions = [
      "--layout=reverse"
      "--cycle"
      "--height=50%"
      "--margin=5%"
      "--border=double"
    ];
  };
}

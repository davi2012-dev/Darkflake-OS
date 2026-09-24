{ lib, pkgs, ... }:

{
  programs.fish = {
    enable = true;
    generateCompletions = true;

    plugins = [
      {
        name = "colored-man-pages";
        src = pkgs.fishPlugins.colored-man-pages.src;
      }
      {
        name = "done";
        src = pkgs.fishPlugins.done.src;
      }
      {
        name = "grc";
        src = pkgs.fishPlugins.grc.src;
      }
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair.src;
      }
      {
        name = "bang-bang";
        src = pkgs.fishPlugins.bang-bang.src;
      }
      {
        name = "sponge";
        src = pkgs.fishPlugins.sponge.src;
      }
      {
        name = "puffer";
        src = pkgs.fishPlugins.puffer.src;
      }
      {
        name = "pisces";
        src = pkgs.fishPlugins.pisces.src;
      }
      {
        name = "plugin-git";
        src = pkgs.fishPlugins.plugin-git.src;
      }
    ];

    shellAbbrs = {
      cl = "clear";
      j = "jj";
      js = "jj status";
      jd = "jj diff";
      jl = "jj log";
      jc = "jj commit";
      jcm = "jj commit -m";
      je = "jj edit";
      jb = "jj bookmark";
      jt = "jj tag";
      jr = "jj restore";
      ju = "jj undo";
      jf = "jj fix";
      jn = "jj next";
      jp = "jj prev";
      jsp = "jj split";
      jsq = "jj squash";
      jdesc = "jj describe";
      jab = "jj abandon";
      jshow = "jj show";
      jrebase = "jj rebase";
      jredo = "jj redo";
      jresolve = "jj resolve";
      jrevert = "jj revert";
      jnew = "jj new";
      jg = "jj git";
      jgf = "jj git fetch";
      jgp = "jj git push";
      jgi = "jj git init";
      jclone = "jj git clone";
      jop = "jj operation";
      jopl = "jj operation log";
      jw = "jj workspace";
      jwa = "jj workspace add";
      jwf = "jj workspace forget";
      jwl = "jj workspace list";
      jwr = "jj workspace rename";
      jwroot = "jj workspace root";
      jwu = "jj workspace update-stale";
      nv = "nvim";
      weather = "curl 'https://wttr.in'";
      dotdot = {
        regex = "^\\.\\.+$";
        function = "multicd";
      };
      g = "git";
      gs = "git status";
      ga = "git add";
      gaa = "git add --all";
      gc = "git commit";
      gcm = "git commit -m";
      gco = "git checkout";
      gcb = "git checkout -b";
      gb = "git branch";
      gbd = "git branch -d";
      gbm = "git branch -m";
      gl = "git log --oneline --graph";
      gd = "git diff";
      gds = "git diff --staged";
      gp = "git push";
      gpf = "git push --force-with-lease";
      gpl = "git pull";
      gcl = "git clone";
      gr = "git remote";
      grv = "git remote -v";
      gra = "git remote add";
    };

    shellAliases = {
      l = lib.mkForce "eza --color=auto --icons=auto --long --all --header --time-style=long-iso";
      ll = lib.mkForce "eza --color=auto --icons=auto --long --all --header --time-style=long-iso";
      lt = lib.mkForce "eza --color=auto --icons=auto --tree --level=2";
      la = lib.mkForce "eza --color=auto --icons=auto --all";
      tree = lib.mkForce "eza --color=auto --icons=auto --tree";
      grep = "grep --color=auto";
      df = "df -h";
      du = "du -h";
      free = "free -h";
      ps = "ps aux";
      ports = "ss -tulpn";
    };

    functions = {
      multicd = {
        description = ".. to cd .., ... to cd ../.., etc.";
        body = ''
          echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
        '';
      };

      mkcd = ''
        command mkdir $argv
        if [ $status = 0 ]
          switch $argv[(count $argv)]
            case '-*'
            case '*'
              cd $argv[(count $argv)]
              return
          end
        end
      '';

      numfiles = ''
        set -l num $(ls -A $argv | wc -l)
        [ -n $num ]; and echo "$num files in $argv"
      '';

      tarmake = "tar -czvf $argv[1].tar.gz $argv[1]";
      tarunmake = "tar -zxvf $argv[1]";

      ln_resolve = {
        description = "Create a symlink using absolute path";
        body = ''
          if test (count $argv) -ne 2
            echo "Usage: ln_resolve <source> <target>"
            return 1
          end
          set -l source (realpath $argv[1])
          set -l target (realpath $argv[2])
          ln -s "$source" "$target"
          if test $status -eq 0
            echo "Symlink created: $target -> $source"
          end
        '';
      };

      fzf-history = {
        description = "Search command history with fzf";
        body = ''
          history | fzf --tac --no-sort | read -l cmd
          if test -n "$cmd"
            commandline -rb "$cmd"
          end
        '';
      };

      f = {
        description = "Find file with fzf and open in nvim";
        body = ''
          set -l file (fd --type f --hidden --exclude .git | fzf)
          if test -n "$file"
            nvim $file
          end
        '';
      };

      d = {
        description = "Find directory with fzf and cd";
        body = ''
          set -l dir (fd --type d --hidden --exclude .git | fzf)
          if test -n "$dir"
            cd $dir
          end
        '';
      };

      gs = {
        description = "Git status with fzf";
        body = ''
          git status --short | fzf --multi --preview 'git diff --color=always {+1}' | awk '{print $2}' | xargs git add
        '';
      };

      theme = {
        description = "Change fish theme";
        body = ''
          if test -z "$argv[1]"
            fish_config theme list
          else
            fish_config theme choose $argv[1]
          end
        '';
      };

      fish_logo_custom = {
        description = "Show custom fish logo";
        body = ''
          fish_logo red f70 yellow "[" "O"
        '';
      };

      fish_greeting = {
        description = "OLIVER SAYS HI";
        body = ''
          set -l normal (set_color normal)
          set -l cyan (set_color -o cyan)
          set -l brcyan (set_color -o brcyan)
          set -l green (set_color -o green)
          set -l brgreen (set_color -o brgreen)
          set -l red (set_color -o red)
          set -l brred (set_color -o brred)
          set -l blue (set_color -o blue)
          set -l brblue (set_color -o brblue)
          set -l magenta (set_color -o magenta)
          set -l brmagenta (set_color -o brmagenta)
          set -l yellow (set_color -o yellow)
          set -l bryellow (set_color -o bryellow)
          set -l beige (set_color -o bba592)

          fish_logo red f70 yellow "[" "O"
          under-the-sea

          set -l olivers \
          '
               \/   \/
               |\__/,|     _
             _.|o o  |_   ) )
            -(((---(((--------
            ' \
            '
               \/       \/
               /\_______/\
              /   o   o   \
             (  ==  ^  ==  )
              )           (
             (             )
             ( (  )   (  ) )
            (__(__)___(__)__)
            ' \
            '
                                   _
                  |\      _-``---,) )
            ZZZzz /,`.-```    -.   /
                 |,4-  ) )-,_. ,\ (
                ---``(_/--`  `-`\_)
            ' \
            '
                  \/ \/
                  /\_/\ _______
                 = o_o =  _ _  \     _
                 (__^__)   __(  \.__) )
              (@)<_____>__(_____)____/
                ♡ ~~ ♡ OLIVER ♡ ~~ ♡
            ' \
            '
               \/   \/
               |\__/,|        _
               |_ _  |.-----.) )
               ( T   ))        )
              (((^_(((/___(((_/
            ' \
            '
            You found the only "fish" that Oliver could not eat!
                   .
                  ":"
                ___:____     |"\/"|
              ,`        `.    \  /
              |  O        \___/  |
            ~^~^~^~^~^~^~^~^~^~^~^~^~
            '
          set -l oliver "$(random choice $olivers)"
          set -l fish_ver $(fish --version)
          set -l uptime $(uptime | grep -ohe 'up .*' | sed 's/,//g' | awk '{ print $2" "$3 " " }')

          colorscript --random

          echo
          echo -e "  " "$brgreen"  "Meow"                              "$normal"
          echo -e "  " "$beige"    "$oliver"                           "$normal"
          echo -e "  " "$cyan"     "  Shell:\t"   "$brcyan$fish_ver"  "$normal"
          echo -e "  " "$blue"     "  Uptime:\t"  "$brblue$uptime"    "$normal"
          echo
        '';
      };
    };

    interactiveShellInit = ''
      fish_vi_key_bindings
      set fish_cursor_default block
      set fish_cursor_insert line
      set fish_cursor_replace_one underscore
      set fish_cursor_visual block
      set fish_vi_force_cursor

      set -gx FZF_DEFAULT_COMMAND "fd --hidden --exclude .git"
      set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
      set -gx FZF_ALT_C_COMMAND "fd --type d --hidden --exclude .git"
      set -gx FZF_DEFAULT_OPTS "--color=bg+:#2b213a,bg:#1a1823,spinner:#f08f8f,hl:#6f9ed9 --prompt='🔍 '"

      bind \cf 'fzf-fish --insert'
      bind \cr 'fzf-history'
      bind \cg 'gss'

      set -g puffer_expand 2

      if command -v zoxide > /dev/null
        zoxide init fish | source
      end
      alias j='z'
      alias ji='zi'

      set -g sponge_frequency 100
      set -g sponge_exclude "ls|cd|clear|exit"

      set -g fish_abbreviation_tips_enabled 1
      set -g fish_abbreviation_tips_delay 2

      fish_config theme choose dracula
    '';
  };
}

{ pkgs, ... }:
{
  home.packages = with pkgs; [
    git-filter-repo
    git-crypt
    gh
    jujutsu
  ];

  programs.git = {
    enable = true;
    
    settings = {
      # --- Usuário e Identidade ---
      user = {
        name = "davi2012-dev";
        email = "DaviMigue@proton.me";
      };

      # --- Editor e Display (OTIMIZADO PARA VSCODE) ---
      core = {
        editor = "code --wait";
        pager = "less";
        autocrlf = "input";
        fsmonitor = true;
        untrackedCache = true;
        ignorecase = false;
      };

      # --- Color e Display ---
      color.pager = false;
      color.ui = "auto";
      diff.colorMoved = "dimmed-zebra";
      log.decorate = "auto";

      # --- Fetch e Pull ---
      fetch.prune = true;
      fetch.pruneTags = true;
      pull.rebase = true;
      pull.ff = "only";
      rebase.autoStash = true;

      # --- Push (Seguro) ---
      push.default = "current";
      push.autoSetupRemote = true;
      push.followTags = true;
      push.recurseSubmodules = "on-demand";

      # --- Init e Status ---
      init.defaultBranch = "main";
      status.short = true;
      status.showUntrackedFiles = "all";

      # --- Network ---
      https.postbuffer = 157286400;
      http.lowSpeedTime = 0;
      http.lowSpeedLimit = 0;

      # --- Diff e Merge (OTIMIZADO PARA VSCODE) ---
      diff.algorithm = "histogram";
      merge.tool = "code";
      mergetool.code.cmd = "code --wait $MERGED";
      diff.tool = "code";
      difftool.code.cmd = "code --wait --diff $LOCAL $REMOTE";

      # --- Submodules ---
      submodule.recurse = true;
      submodule.fetchJobs = 4;

      # --- CORREÇÃO: Aliases movidos para dentro de settings.alias ---
      alias = {
        # --- Status e Log ---
        s = "status";
        ss = "status --short";
        l = "log --oneline -n 10";
        ll = "log --graph --oneline --all";
        lls = "log --graph --oneline --all --simplify-by-decoration";
        
        # --- Branches ---
        b = "branch";
        ba = "branch -a";
        bm = "branch --merged";
        bnm = "branch --no-merged";
        
        # --- Checkout ---
        co = "checkout";
        cob = "checkout -b";
        com = "checkout main";
        cod = "checkout develop";
        
        # --- Commit ---
        c = "commit -m";
        ca = "commit -am";
        cam = "commit --amend";
        cane = "commit --amend --no-edit";
        
        # --- Push & Pull ---
        p = "push";
        pl = "pull";
        plr = "pull --rebase";
        pf = "push --force-with-lease";
        po = "push origin";
        pob = "push -u origin HEAD";
        
        # --- Fetch ---
        f = "fetch";
        fa = "fetch --all";
        
        # --- Add e Reset ---
        a = "add";
        aa = "add .";
        ap = "add -p";
        un = "reset HEAD --";
        undo = "reset --soft HEAD~1";
        
        # --- Diff ---
        d = "diff";
        ds = "diff --staged";
        dv = "difftool";
        
        # --- Merge ---
        m = "merge";
        ma = "merge --abort";
        
        # --- Stash ---
        st = "stash";
        sta = "stash apply";
        stl = "stash list";
        stp = "stash pop";
        std = "stash drop";
        
        # --- Rebase ---
        rb = "rebase";
        rbi = "rebase -i";
        rbc = "rebase --continue";
        rba = "rebase --abort";
        
        # --- Tags ---
        t = "tag";
        ta = "tag -a";
        
        # --- Cleanup ---
        clean = "clean -fd";
        clang = "clean -fd && git reset --hard";
        
        # --- Useful ---
        last = "log -1 HEAD";
        show = "show --pretty=fuller";
        amend = "commit --amend --no-edit";
        open = "code .";
        alias = "config --get-regexp alias";
        who = "shortlog -s -n";
        count = "rev-list --count HEAD";
        root = "rev-parse --show-toplevel";
      };
    };

    ignores = [
      # --- OS ---
      ".DS_Store" ".directory" "Thumbs.db"
      
      # --- VSCode ---
      ".vscode/" "*.code-workspace"
      
      # --- IDEs ---
      ".idea/" ".vim/" "*.swp" "*.swo" "*~"
      ".envrc" ".dirlocals"
      
      # --- Build ---
      "*.o" "*.a" "*.so" "*.exe" "*.out"
      "dist/" "build/" "target/"
      "node_modules/" "__pycache__/" ".venv/" "venv/"
      
      # --- Docs & Web ---
      "*.xml" "*.iml"
      "npm-debug.log" "yarn-error.log"
      
      # --- LaTeX ---
      "*.aux" "*.lof" "*.log" "*.lot" "*.fls" "*.out"
      "*.toc" "*.fmt" "*.fot" "*.cb" "*.cb2" ".*.lb"
      "*.synctex.gz" "*.bbl" "*.bcf" "*.blg"
      
      # --- Secrets ---
      ".env" ".env.local" "secrets/" "credentials.json"
      "*.key" "*.pem" "id_rsa"
    ];
  };
}

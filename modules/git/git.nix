{
  xdg.configFile."git/work".source = ./work.conf;

  programs.diff-so-fancy = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.git = {
    enable = true;
    ignores = [
      "_private/"
      ".envrc"
      ".direnv/"
      ".ctags.d/"
    ];
    includes = [
      {
        condition = "gitdir:~/dev/anyfin/";
        path = "./work";
      }
    ];
    settings = {
      user = {
        name = "Viktor Malmedal";
        email = "38523983+johnvicke@users.noreply.github.com";
      };
      init = {
        defaultBranch = "main";
      };
      pager = {
        show = "bat";
      };
      color = {
        ui = "auto";
      };
      status = {
        showStash = true;
      };
      push = {
        default = "simple";
        autoSetupRemote = true;
      };
      pull = {
        ff = "only";
      };
      diff = {
        colorMoved = true;
        colorMovedWS = "allow-indentation-change";
      };
      alias = {
        fu = "!git add . && git commit --fixup=HEAD && git push --force-with-lease";
        lg = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all";
        oops = "commit --amend --no-edit";
        review-local = "!git lg @{push}..'";
        uncommit = "reset --soft HEAD~1";
        reword = "commit --amend";
        lease = "push --force-with-lease";
        wip = "!git add . && git commit -m 'wip' --no-verify && git push --no-verify";
        tb = "!git commit --allow-empty -m 'Triggering build process' && git push";

        # -- Stacked PR helpers --

        # Create a new branch stacked on current branch
        stack = "!f() { current=$(git branch --show-current); git checkout -b \"$1\" && git config branch.\"$1\".stackParent \"$current\" && echo \"Created $1 stacked on $current\"; }; f";

        # Update from parent: fetch parent and rebase current branch onto it
        update-from-parent = "!f() { current=$(git branch --show-current); parent=$(git config branch.$current.stackParent); if [ -z \"$parent\" ]; then echo \"No parent set for $current\"; exit 1; fi; echo \"Rebasing $current onto $parent...\"; git fetch origin $parent && git rebase origin/$parent && git lease; }; f";

        # After parent squash-merge: rebase onto main and update parent to main
        parent-merged = "!f() { current=$(git branch --show-current); parent=$(git config branch.$current.stackParent); if [ -z \"$parent\" ]; then echo \"No parent set for $current\"; exit 1; fi; echo \"Rebasing $current onto main (parent $parent was merged)...\"; git fetch origin && git rebase --onto origin/main origin/$parent && git config branch.$current.stackParent main && git lease && echo \"Done! Parent updated to main.\"; }; f";

        # Show stack: display the stack of branches leading to current branch
        show-stack = "!f() { current=$(git branch --show-current); echo \"Branch stack for $current:\"; while [ -n \"$current\" ]; do echo \"$current\"; current=$(git config branch.$current.stackParent); done; }; f";

        # -- End Stacked PR helpers --
      };
    };
  };
}

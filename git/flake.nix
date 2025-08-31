{
  xdg.configFile."git/work".source = ./work.conf;
  programs.git = {
    enable = true;
    userName = "Viktor Malmedal";
    userEmail = "38523983+johnvicke@users.noreply.github.com";
    diff-so-fancy = { enable = true; };
    extraConfig = {
      init = { defaultBranch = "main"; };
      pager = { show = "bat"; };
      color = { ui = "auto"; };
      status = { showStash = true; };
      push = { default = "simple"; };
      pull = { ff = "only"; };
      diff = {
        colorMoved = true;
        colorMovedWS = "allow-indentation-change";
      };
    };
    aliases = {
      lg = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all";
      oops = "commit --amend --no-edit";
      review-local="!git lg @{push}..'";
      uncommit = "reset --soft HEAD~1";
      reword = "commit --amend";
      lease = "push --force-with-lease";
      tb = "!git commit --allow-empty -m '🛠️ Triggering build process' && git push";
    };
    includes = [{
      condition ="gitdir:~/dev/anyfin/";
      path="./work";
    }];
  };
}

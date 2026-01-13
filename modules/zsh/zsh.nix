{lib, ...}: {
  programs = {
    zsh = {
      enable = true;
      enableCompletion = false;
      initContent = lib.mkMerge [
        (lib.mkOrder 500 ''
          if [ -n "''${ZSH_DEBUGRC+1}" ]; then
             zmodload zsh/zprof
          fi

          # Source secrets if present
          [ -f ~/.secrets ] && source ~/.secrets

          zstyle ':completion:*' use-cache on
          zstyle ':completion:*' cache-path ~/.zsh/cache
          mkdir -p ~/.zsh/cache
          autoload -Uz compinit && compinit -C

        '')
        (lib.mkOrder 1500 ''
          # Late initialization
          zvm_after_init() {
            bindkey '^R' fzf-history-widget
          }

          if [ -n "''${ZSH_DEBUGRC+1}" ]; then
             zprof
          fi
        '')
      ];
      antidote = {
        enable = true;
        plugins = [
          "zsh-users/zsh-autosuggestions"
          "jeffreytse/zsh-vi-mode"
          "zsh-users/zsh-syntax-highlighting"
        ];
      };
      shellAliases =
        {
          pn = "pnpm";
          cat = "bat";
          find = "fd";
          grep = "rg";
          ls = "exa";
          t = "tmux";
          v = "nvim";
        }
        // builtins.listToAttrs (
          map (i: {
            name = builtins.concatStringsSep "" (builtins.genList (_: ".") (i + 1));
            value = "cd " + (builtins.concatStringsSep "/" (builtins.genList (_: "..") i));
          }) (builtins.genList (x: x + 1) 5)
        );
    };
  };
}

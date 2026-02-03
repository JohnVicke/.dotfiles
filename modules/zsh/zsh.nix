{
  config,
  lib,
  ...
}: let
  cfgHome = config.xdg.configHome or "${config.home.homeDirectory}/.config";
  cacheHome = config.xdg.cacheHome or "${config.home.homeDirectory}/.cache";
  zshConfigDir = "${cfgHome}/zsh";
  zshCacheDir = "${cacheHome}/zsh";
  initSource = "${zshConfigDir}/hm-init.zsh";
  compiledInit = "${zshCacheDir}/hm-init.zsh.zwc";
  compdump = "${zshCacheDir}/zcompdump";
in {
  xdg.configFile."zsh/hm-init.zsh".source = ./init.zsh;

  home.activation.ensureZshCacheDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p ${zshCacheDir}
  '';

  home.activation.compileZshInit = lib.hm.dag.entryAfter ["ensureZshCacheDir"] ''
    if command -v zsh >/dev/null 2>&1; then
      zsh -fc 'zcompile -R "${compiledInit}" "${initSource}"'
    fi
  '';

  home.activation.primeZcompdump = lib.hm.dag.entryAfter ["compileZshInit"] ''
    if command -v zsh >/dev/null 2>&1; then
      ZDOTDIR="${zshConfigDir}" HOME="${config.home.homeDirectory}" \
        zsh -fc 'autoload -Uz compinit && compinit -d "${compdump}" -C'
    fi
  '';

  programs.zsh = {
    enable = true;
    enableCompletion = false;
    initExtraFirst = ''
      if [[ -r "${compiledInit}" ]]; then
        source "${compiledInit}"
      elif [[ -r "${initSource}" ]]; then
        source "${initSource}"
      fi
    '';
    antidote = {
      enable = true;
      plugins = [
        "zsh-users/zsh-autosuggestions"
        "jeffreytse/zsh-vi-mode"
        "zsh-users/zsh-syntax-highlighting"
        "romkatv/zsh-defer"
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
}

export PATH="$HOME/.nix-profile/bin:$PATH:$HOME/.opencode/bin"

if [[ -n "${ZSH_DEBUGRC-}" ]]; then
  zmodload zsh/zprof
fi

[[ -f "$HOME/.secrets" ]] && source "$HOME/.secrets"

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

autoload -Uz compinit
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump" ]]; then
  compinit -C -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
else
  compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
fi

zvm_after_init() {
  bindkey '^R' fzf-history-widget
}

if typeset -f zsh-defer >/dev/null 2>&1; then
  zsh-defer bindkey '^R' fzf-history-widget
else
  bindkey '^R' fzf-history-widget
fi

profzsh() {
  ZSH_DEBUGRC=1 ${SHELL:-zsh} -i -c exit
}

if [[ -n "${ZSH_DEBUGRC-}" ]]; then
  zprof
fi

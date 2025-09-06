if [ -n "${ZSH_DEBUGRC+1}" ]; then
    zmodload zsh/zprof
fi

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source_if_exists () {
    if test -r "$1"; then
        source "$1"
    fi
}

export DOTFILES=$HOME/.dotfiles

source_if_exists $DOTFILES/zsh/env
source_if_exists $DOTFILES/zsh/paths
source_if_exists $DOTFILES/zsh/alias

plugins=(git zsh-autosuggestions zsh-vi-mode zsh-z zsh-syntax-highlighting zsh-npm-scripts-autocomplete)

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=60'

source $ZSH/oh-my-zsh.sh

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

fpath=($fpath "$HOME/.zfunctions")

autoload -U promptinit; promptinit

if [[ $TERM == xterm* ]]; then
  export TERM=xterm-256color;
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

eval "$(starship init zsh)"
eval "$(fnm env --use-on-cd)"
eval "$(fzf --zsh)"
eval "$(direnv hook zsh)"

ZVM_VI_INSERT_ESCAPE_BINDKEY=kj

eval "`fnm env`"

export PYENV_ROOT="$HOME/.pyenv"

[[ -d $PYENV_ROOT/bin ]] && addToPath $PYENV_ROOT/bin

eval "$(pyenv init -)"
eval "$(~/.rbenv/bin/rbenv init - zsh)"

zvm_after_init_commands+=('source_if_exists $DOTFILES/zsh/after-vi-init')

[ -s "/home/viktor/.bun/_bun" ] && source "/home/viktor/.bun/_bun"

[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

if [ -e /home/viktor/.nix-profile/etc/profile.d/nix.sh ]; then . /home/viktor/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

export PATH=/home/viktor/.opencode/bin:$PATH


if [ -n "${ZSH_DEBUGRC+1}" ]; then
    zprof
fi

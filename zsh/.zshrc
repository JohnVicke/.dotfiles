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



# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

fpath=($fpath "$HOME/.zfunctions")

autoload -U promptinit; promptinit

if [[ $TERM == xterm* ]]; then
  TERM=xterm-256color;
fi


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


# bun completions
[ -s "/home/viktor/.bun/_bun" ] && source "/home/viktor/.bun/_bun"

eval "$(starship init zsh)"
eval "$(fnm env --use-on-cd)"
eval "$(fzf --zsh)"

case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

ZVM_VI_INSERT_ESCAPE_BINDKEY=kj

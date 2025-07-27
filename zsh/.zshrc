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
  export TERM=xterm-256color;
fi


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# bun completions

eval "$(starship init zsh)"
eval "$(fnm env --use-on-cd)"
eval "$(fzf --zsh)"

case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

ZVM_VI_INSERT_ESCAPE_BINDKEY=kj

eval "`fnm env`"

export NVM_DIR="$HOME/.nvm"

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && addToPath $PYENV_ROOT/bin
eval "$(pyenv init -)"
eval "$(~/.rbenv/bin/rbenv init - zsh)"

zvm_after_init_commands+=('source_if_exists $DOTFILES/zsh/after-vi-init')
[ -s "/home/viktor/.bun/_bun" ] && source "/home/viktor/.bun/_bun"

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# add Pulumi to the PATH
export PATH=$PATH:/home/viktor/.pulumi/bin

if [ -e /home/viktor/.nix-profile/etc/profile.d/nix.sh ]; then . /home/viktor/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

# pnpm
export PNPM_HOME="/home/viktor/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# opencode
export PATH=/home/viktor/.opencode/bin:$PATH

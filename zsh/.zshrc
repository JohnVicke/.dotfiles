if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="/home/viktor/.oh-my-zsh"

plugins=(git zsh-autosuggestions zsh-vi-mode zsh-z zsh-syntax-highlighting)

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=60'

# export RPS1="%{$reset_color%}"

source $ZSH/oh-my-zsh.sh

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

alias nrd="npm run dev"
alias pn="pnpm"
alias wta="~/.dotfiles/gwta.sh"

alias pbcopy="xclip -sel clip"
alias pbpaste="xclip -sel clip -o"
alias zshconfig="v ~/.zshrc"
alias tmuxconfig="v ~/.tmux.conf"
alias vimconfig="v ~/.config/nvim/init.vim"
alias ^L=clear

alias c="code"
alias cr="code -r"
alias cr.="code -r ."
alias tdi="td --interactive"

alias vim="nvim"
alias vi="nvim"
alias v="nvim"
alias oldvim="vim"
alias nvimdiff="nvim -d"
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias enirovpn="sudo openvpn --config ~/.eniroconfig/enirovpn2.vpn"
alias gwtab="git checkout wo"

alias ..='cd ../'                      # Go back 1 directory level
alias ...='cd ../../'                  # Go back 2 directory levels
alias .3='cd ../../../'                # Go back 3 directory levels
alias .4='cd ../../../../'             # Go back 4 directory levels
alias .5='cd ../../../../../'          # Go back 5 directory levels
alias .6='cd ../../../../../../'       # Go back 6 directory levels

alias l='exa --color=always --group-directories-first'      # some files and dirs
alias la='exa --header --long'  
alias ll='exa -1 --color=always --group-directories-first'  # long format
alias ls='exa -a1 --color=always --group-directories-first' # my preferred listing
alias bat="batcat"

alias kubectl="minikube kubectl --"

export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
GOPATH=~/go
export PATH=$PATH:/usr/local/go/bin


lg()
{
    export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir

    lazygit "$@"

    if [ -f $LAZYGIT_NEW_DIR_FILE ]; then
            cd "$(cat $LAZYGIT_NEW_DIR_FILE)"
            rm -f $LAZYGIT_NEW_DIR_FILE > /dev/null
    fi
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh"  # This loads nvm
alias confi='/usr/bin/it --it-dir=/home/viktor/.cf/ --work-tree=/home/viktor'

fpath=($fpath "/home/viktor/.zfunctions")

autoload -U promptinit; promptinit
export TERM=xterm-256color

if [[ $TERM == xterm* ]]; then
  TERM=xterm-256color;
fi



export DENO_INSTALL="/home/viktor/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# bun completions
[ -s "/home/viktor/.bun/_bun" ] && source "/home/viktor/.bun/_bun"

spaceship_vi_mode_enable
# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
eval "$(starship init zsh)"

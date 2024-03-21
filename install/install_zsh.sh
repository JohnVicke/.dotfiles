#!/bin/sh

echo "Installing ZSH with OH-MY-ZSH..."
sudo apt install zsh -y

echo "Installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Vim mode
git clone https://github.com/jeffreytse/zsh-vi-mode \
  $ZSH/custom/plugins/zsh-vi-mode

# Z jump
git clone https://github.com/agkozak/zsh-z $ZSH_CUSTOM/plugins/zsh-z

# Autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions

# Syntax highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
echo "source ${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc

git clone git@github.com:grigorii-zander/zsh-npm-scripts-autocomplete.git ~/${ZSH_CUSTOM}/plugins/zsh-npm-scripts-autocomplete


echo "Changing shell to zsh"
chsh -s "$(which zsh)"


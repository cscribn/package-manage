#!/bin/bash

sudo apt install curl -y
sudo apt install git -y

# oh-my-posh
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-arm -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh

# raspi2png
git clone https://github.com/AndrewFromMelbourne/raspi2png
sudo cp -a raspi2png/raspi2png /usr/local/bin

# ruby
sudo apt install rbenv -y
sudo apt remove ruby-build -y
export PATH="$HOME/.rbenv/bin:$PATH"
rm -rf ~/.rbenv/plugins/ruby-build

git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

eval "$(rbenv init -)"
ruby_installed=$(head -n 1 ~/.rbenv/version | tr -d '[[:space:]]')
ruby_latest=$(rbenv install --list-all | grep -v - | tail -1 | tr -d '[[:space:]]')

if [ "$ruby_installed" != "$ruby_latest" ]; then
    rbenv uninstall -f "$ruby_installed"
    rbenv install --verbose "$ruby_latest"
    rbenv global "$ruby_latest"
fi

sudo apt install unzip -y

# vim
sudo apt install vim -y

curl -Lo "$HOME/.vimrc" https://raw.githubusercontent.com/cscribn/config-misc/main/vim/vimrc

# zsh
sudo apt install zsh -y
rm -rf ~/.config/zsh

git clone https://github.com/cscribn/config-zsh.git  ~/.config/zsh

cp ~/.config/zsh/zshrc-pi ~/.zshrc
rm -rf ~/.zsh/zsh-autocomplete
rm -rf ~/.zsh/zsh-autosuggestions
rm -rf ~/.zsh/zsh-syntax-highlighting

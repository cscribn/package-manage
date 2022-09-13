#!/bin/bash

sudo apt install curl -y
sudo apt install git -y

# oh-my-posh
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-arm -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh

# ruby
sudo apt install rbenv -y
sudo apt remove ruby-build -y
export PATH="$HOME/.rbenv/bin:$PATH"
rm -rf ~/.rbenv/plugins/ruby-build
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
eval "$(rbenv init -)"
rbenv uninstall -f $(head -n 1 ~/.rbenv/version | tr -d '[[:space:]]')
ruby_version=$(rbenv install --list-all | grep -v - | tail -1 | tr -d '[[:space:]]')
rbenv install --verbose "$ruby_version"
rbenv global "$ruby_version"
gem install colorls
rm -rf ~/.config/colorls
git clone https://github.com/cscribn/config-colorls.git  ~/.config/colorls

sudo apt install unzip -y
sudo apt install vim -y

# zsh
sudo apt install zsh -y
rm -rf ~/.config/zsh
git clone https://github.com/cscribn/config-zsh.git  ~/.config/zsh
cp ~/.config/zsh/zshrc-pi ~/.zshrc
rm -rf ~/.zsh/zsh-autocomplete
rm -rf ~/.zsh/zsh-autosuggestions
rm -rf ~/.zsh/zsh-syntax-highlighting

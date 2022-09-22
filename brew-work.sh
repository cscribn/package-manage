#!/bin/bash

brew tap homebrew/cask-versions
brew install git || brew upgrade git

brew install --cask amazon-workspaces || brew upgrade --cask amazon-workspaces
brew install awscli || brew upgrade awscli
brew install --cask barrier || brew upgrade --cask barrier
brew install bash || brew upgrade bash
brew install --cask bbedit
# manual: embrava
brew install --cask docker || brew upgrade --cask docker
brew install --cask firefox || brew upgrade --cask firefox
brew install --cask gimp || brew upgrade --cask gimp
brew install --cask font-meslo-lg-nerd-font || brew upgrade --cask font-meslo-lg-nerd-font
brew install --cask github || brew upgrade --cask github
brew install --cask google-chrome || brew upgrade --cask google-chrome
brew install --cask google-chrome-beta || brew upgrade --cask google-chrome-beta
brew install --cask google-drive || brew upgrade --cask google-drive
brew install --cask gpg-suite || brew upgrade --cask gpg-suite
brew install --cask iterm2 || brew upgrade --cask iterm2

# node
brew install nvm || brew upgrade nvm
nvm uninstall latest
nvm install latest
nvm install 10.24.1
nvm install 12.13.0

# oh-my-posh
brew install oh-my-posh || brew upgrade oh-my-posh
rm -rf ~/.config/oh-my-posh
git clone https://github.com/cscribn/config-oh-my-posh.git  ~/.config/oh-my-posh

brew install --cask onedrive || brew upgrade --cask onedrive
# manual: paste plain text
# manual: peazip
brew install --cask pinta || brew upgrade --cask pinta
brew install --cask postman || brew upgrade --cask postman
brew install --cask powershell || brew upgrade --cask powershell

# python 2
brew install pyenv || brew upgrade pyenv
pyenv install 2.7.18
export PATH="$(pyenv root)/shims:${PATH}"
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
pyenv shell 2.7.18

# ruby
brew install rbenv || brew upgrade rbenv
brew uninstall --ignore-dependencies ruby-build
rm -rf ~/.rbenv/plugins/ruby-build
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
eval "$(rbenv init -)"
rbenv uninstall -f $(head -n 1 ~/.rbenv/version | tr -d '[[:space:]]')
ruby_version=$(rbenv install --list-all | grep -v - | tail -1 | tr -d '[[:space:]]')
rbenv install --verbose "$ruby_version"
rbenv global "$ruby_version"
gem install colorls
rm -rf ~/.config/colorls
curl -Lo ~/.config/colorls/dark_colors.yaml --create-dirs https://raw.githubusercontent.com/cscribn/config-misc/main/colorls/dark_colors_ansi.yaml

brew install --cask slack || brew upgrade --cask slack
brew install --cask studio-3t || brew upgrade --cask studio-3t
brew install --cask visual-studio-code || brew upgrade --cask visual-studio-code
brew install vim || brew upgrade vim
brew install --cask vlc || brew upgrade --cask vlc
# manual: xcode
brew install yarn || brew upgrade yarn

# zsh
brew install zsh || brew upgrade zsh
rm -rf ~/.config/zsh
git clone https://github.com/cscribn/config-zsh.git  ~/.config/zsh
cp ~/.config/zsh/zshrc-mac ~/.zshrc
rm -rf ~/.zsh/zsh-autocomplete
rm -rf ~/.zsh/zsh-autosuggestions
rm -rf ~/.zsh/zsh-syntax-highlighting

brew install --cask zoom || brew upgrade --cask zoom

brew upgrade && brew upgrade --cask
brew autoremove
brew cleanup

#!/bin/bash

brew tap homebrew/cask-versions

brew install --cask amazon-workspaces --force
brew install --cask barrier --force
brew install bash --force
# manual: embrava
brew install --cask docker --force
brew install --cask firefox --force
brew install --cask gimp --force
brew install --cask font-meslo-lg-nerd-font --force
brew install git --force
brew install --cask github --force
brew install --cask google-chrome --force
brew install --cask google-chrome-beta --force
brew install --cask google-drive --force
brew install --cask gpg-suite --force
brew install --cask iterm2 --force
brew install nvm --force

# oh-my-posh
brew install oh-my-posh --force
rm -rf ~/.config/oh-my-posh
git clone https://github.com/cscribn/config-oh-my-posh.git  ~/.config/oh-my-posh

brew install --cask onedrive --force
# manual: paste plain text
brew install --cask pinta --force
brew install --cask postman --force
brew install --cask powershell --force

# ruby
brew install rbenv --force
brew uninstall ruby-build
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

brew install --cask slack --force
brew install --cask skitch --force
brew install --cask studio-3t --force
brew install --cask the-unarchiver --force
brew install --cask visual-studio-code --force
brew install vim --force
brew install --cask vlc --force
# manual: xcode
brew install yarn --force

# zsh
brew install zsh --force
rm -rf ~/.config/zsh
git clone https://github.com/cscribn/config-zsh.git  ~/.config/zsh
cp ~/.config/zsh/zshrc-mac ~/.zshrc
rm -rf ~/.zsh/zsh-autocomplete
rm -rf ~/.zsh/zsh-autosuggestions
rm -rf ~/.zsh/zsh-syntax-highlighting

brew install --cask zoom --force


brew upgrade && brew upgrade --cask

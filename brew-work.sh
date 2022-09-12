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
brew install oh-my-posh --force
brew install --cask onedrive --force
# manual: paste plain text
brew install --cask pinta --force
brew install --cask postman --force
brew install --cask powershell --force
brew install rbenv --force
brew uninstall ruby-build
brew install --cask slack --force
brew install --cask skitch --force
brew install --cask studio-3t --force
brew install --cask the-unarchiver --force
brew install --cask visual-studio-code --force
brew install vim --force
brew install --cask vlc --force
# manual: xcode
brew install yarn --force
brew install zsh --force
brew install --cask zoom --force


brew upgrade && brew upgrade --cask

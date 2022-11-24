#!/bin/bash

# Non-brew installations (add/update these first)
# embrava
# paste plain text
# peazip

brew update || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew tap homebrew/cask-versions
brew install git || brew upgrade git
xcode-select --install

brew install --cask amazon-workspaces || brew upgrade --cask amazon-workspaces
brew install awscli || brew upgrade awscli
brew install --cask barrier || brew upgrade --cask barrier
brew install bash || brew upgrade bash

# bbedit
brew install --cask bbedit

curl -Lo "$HOME/Library/Application Support/BBEdit/Language Modules/CSharpLanguageModule.plist" https://luminaryapps.com/code/CSharpLanguageModule.plist

curl -Lo "$HOME/Library/Application Support/BBEdit/Language Modules/PowerShell.plist" https://raw.githubusercontent.com/doug-baer/BBEdit-PowerShell/master/PowerShell.plist

brew install coreutils || brew upgrade coreutils
brew install --cask docker || brew upgrade --cask docker

# dotnet-sdk
brew tap isen-ng/dotnet-sdk-versions
brew uninstall --cask --ignore-dependencies dotnet-sdk
# https://github.com/isen-ng/homebrew-dotnet-sdk-versions
brew install --cask dotnet-sdk6-0-400 || brew upgrade --cask dotnet-sdk6-0-400

brew install ffmpeg || brew upgrade ffmpeg
brew install --cask firefox || brew upgrade --cask firefox
brew install --cask forticlient-vpn || brew upgrade --forticlient-vpn
brew install --cask gimp || brew upgrade --cask gimp
brew install --cask font-meslo-lg-nerd-font || brew upgrade --cask font-meslo-lg-nerd-font
brew install gifsicle || brew upgrade gifsicle
brew install git || brew upgrade git
brew install --cask github || brew upgrade --cask github
brew install --cask google-chrome || brew upgrade --cask google-chrome
brew install --cask google-chrome-beta || brew upgrade --cask google-chrome-beta
brew install --cask google-drive || brew upgrade --cask google-drive
brew install --cask gpg-suite || brew upgrade --cask gpg-suite
brew install --cask iterm2 || brew upgrade --cask iterm2
brew install --cask libreoffice || brew upgrade --cask libreoffice

# node
brew uninstall nvm
brew install nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

nvm install latest
nvm install 10.24.1
nvm install 12.13.0

# oh-my-posh
brew install jandedobbeleer/oh-my-posh/oh-my-posh || brew upgrade jandedobbeleer/oh-my-posh/oh-my-posh

cd ~/.config/oh-my-posh || exit
gitmain=$(git rev-parse main)
githead=$(git rev-parse HEAD)
cd - || exit

if [ "$gitmain" -ne "$githead" ]; then
    rm -rf ~/.config/oh-my-posh

    git clone https://github.com/cscribn/config-oh-my-posh.git  ~/.config/oh-my-posh
fi

brew install --cask onedrive || brew upgrade --cask onedrive
brew install perl || brew upgrade perl
brew install php || brew upgrade php
brew install --cask pinta || brew upgrade --cask pinta
brew install --cask postman || brew upgrade --cask postman
brew install --cask powershell || brew upgrade --cask powershell

# python 2
brew install pyenv || brew upgrade pyenv
pyenv install 2.7.18 -f
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

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
ruby_installed=$(head -n 1 ~/.rbenv/version | tr -d '[[:space:]]')
ruby_latest=$(rbenv install --list-all | grep -v - | tail -1 | tr -d '[[:space:]]')

if [ "$ruby_installed" != "$ruby_latest" ]; then
    rbenv uninstall -f "$ruby_installed"
    rbenv install --verbose "$ruby_latest"
    rbenv global "$ruby_latest"
fi

brew install --cask slack || brew upgrade --cask slack
brew install --cask studio-3t || brew upgrade --cask studio-3t
brew install --cask visual-studio-code || brew upgrade --cask visual-studio-code

# vim
brew install vim || brew upgrade vim

curl -Lo "$HOME/.vimrc" https://raw.githubusercontent.com/cscribn/config-misc/main/vim/vimrc

brew install --cask vlc || brew upgrade --cask vlc
brew install yarn || brew upgrade yarn

# zsh
brew install zsh || brew upgrade zsh

cd ~/.config/zsh || exit
gitmain=$(git rev-parse main)
githead=$(git rev-parse HEAD)
cd - || exit

if [ "$gitmain" -ne "$githead" ]; then
    rm -rf ~/.config/zsh

    git clone https://github.com/cscribn/config-zsh.git  ~/.config/zsh
    cp ~/.config/zsh/zshrc-mac ~/.zshrc
fi

cd ~/.zsh/zsh-autocomplete || exit
gitmain=$(git rev-parse main)
githead=$(git rev-parse HEAD)
cd - || exit

if [ "$gitmain" -ne "$githead" ]; then
    rm -rf ~/.zsh/zsh-autocomplete
fi

cd ~/.zsh/zsh-autosuggestions || exit
gitmain=$(git rev-parse main)
githead=$(git rev-parse HEAD)
cd - || exit

if [ "$gitmain" -ne "$githead" ]; then
    rm -rf ~/.zsh/zsh-autosuggestions
fi

cd ~/.zsh/zsh-syntax-highlighting || exit
gitmain=$(git rev-parse main)
githead=$(git rev-parse HEAD)
cd - || exit

if [ "$gitmain" -ne "$githead" ]; then
    rm -rf ~/.zsh/zsh-syntax-highlighting
fi

brew install --cask zoom || brew upgrade --cask zoom

brew autoremove
brew cleanup

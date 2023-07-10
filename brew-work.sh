#!/usr/bin/env bash

# Non-brew installations (add/update these first)
# embrava
# filezilla
# paste plain text

# settings
set -o nounset
set -o pipefail
[[ "${TRACE-0}" = "1" ]] && set -o xtrace

# variables
declare script_name
script_name=$(basename "${0}")
declare script_dir
script_dir="$(dirname "$0")"
declare git_dir
declare git_main
declare git_origin

# usage
if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
	echo "Usage: ./${script_name}"
	exit
fi

export PATH="${PATH}:/opt/homebrew/bin"

brew update || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew tap homebrew/cask-versions
brew tap snyk/tap
brew install git || brew upgrade git

brew install --cask altair-graphql-client || brew upgrade --cask altair-graphql-client
brew install --cask amazon-workspaces || brew upgrade --cask amazon-workspaces
brew install android-platform-tools || brew upgrade android-platform-tools
brew install awscli || brew upgrade awscli
brew install --cask barrier || brew upgrade --cask barrier
brew install bash || brew upgrade bash
brew install --cask bbedit || brew upgrade --cask bbedit
brew install cake || brew upgrade cake
brew install coreutils || brew upgrade coreutils
brew install --cask docker || brew upgrade --cask docker

# dotnet-sdk
brew tap isen-ng/dotnet-sdk-versions
# https://github.com/isen-ng/homebrew-dotnet-sdk-versions
brew install --cask dotnet-sdk6-0-400 || brew upgrade --cask dotnet-sdk6-0-400
brew install --cask dotnet-sdk7-0-200 || brew upgrade --cask dotnet-sdk7-0-200

brew install --cask microsoft-edge || brew upgrade --cask microsoft-edge
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
brew install --cask keka || brew upgrade --cask keka
brew install --cask kekaexternalhelper || brew upgrade --cask kekaexternalhelper
brew install lsd || brew upgrade lsd

# mkcert
brew install mkcert || brew upgrade mkcert
brew install nss || brew upgrade nss

brew install --cask microsoft-teams || brew upgrade --cask microsoft-teams

# node
find "${HOME}/.nvm/versions/node" -depth 1 -type d \
	! -name "v10.24.1" \
	! -name "v12.13.0" \
	! -name "v16.14.0" \
	! -name "v18.15.0" \
	-exec rm -rf {} +

brew install nvm || brew upgrade nvm
export NVM_DIR="${HOME}/.nvm"
[[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ]] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

nvm install node
nvm install 10.24.1
nvm install 12.13.0
nvm install 16.14.0
nvm install 18.15.0
nvm alias default node

# oh-my-posh
brew install jandedobbeleer/oh-my-posh/oh-my-posh || brew upgrade jandedobbeleer/oh-my-posh/oh-my-posh
oh-my-posh disable notice

brew install --cask onedrive || brew upgrade --cask onedrive
brew install perl || brew upgrade perl
brew install php || brew upgrade php
python3 -m pip install -U pip
brew install --cask pinta || brew upgrade --cask pinta
brew install pnpm || brew upgrade pnpm
brew install --cask postman || brew upgrade --cask postman
brew install --cask powershell || brew upgrade --cask powershell

# python 2
brew install pyenv || brew upgrade pyenv
pyenv install 2.7.18 -ffmpeg
PATH="$(pyenv root)/shims:${PATH}"
export PATH
export PYENV_ROOT="${HOME}/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:${PATH}"
eval "$(pyenv init -)"
pyenv shell 2.7.18

# ruby
brew install rbenv || brew upgrade rbenv
rm -rf ~/.rbenv/plugins/ruby-build
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
rbenv install -s 2.7.6

brew install --cask slack || brew upgrade --cask slack
brew install snyk || brew upgrade snyk
brew install --cask studio-3t || brew upgrade --cask studio-3t

# terraform
brew install tfenv || brew upgrade tfenv
tfenv install 1.5.2

brew install --cask visual-studio-code || brew upgrade --cask visual-studio-code
brew install vim || brew upgrade vim
brew install --cask vlc || brew upgrade --cask vlc
brew install yarn || brew upgrade yarn

# zsh
brew install zsh || brew upgrade zsh

git_dir="${HOME}/.zsh/zsh-autosuggestions"

if [[ -d "$git_dir" ]]; then
	cd "$git_dir" || exit
	git fetch
	git_main=$(git rev-parse master)
	git_origin=$(git rev-parse origin/master)
	cd - || exit

	if [[ "$git_main" != "$git_origin" ]]; then
		rm -rf "$git_dir"
	fi
fi

git_dir="${HOME}/.zsh/zsh-syntax-highlighting"

if [[ -d "$git_dir" ]]; then
	cd "$git_dir" || exit
	git fetch
	git_main=$(git rev-parse master)
	git_origin=$(git rev-parse origin/master)
	cd - || exit

	if [[ "$git_main" != "$git_origin" ]]; then
		rm -rf "$git_dir"
	fi
fi

brew install --cask zoom || brew upgrade --cask zoom

brew uninstall --ignore-dependencies dotnet
brew upgrade
brew autoremove
brew cleanup

source "${script_dir}/_brew-work-config.sh"
